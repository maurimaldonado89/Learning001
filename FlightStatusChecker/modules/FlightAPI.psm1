# Flight API Module
# Provides functions to interact with flight status APIs

<#
.SYNOPSIS
Gets flight data from OpenSky Network API

.PARAMETER Icao24
Aircraft ICAO24 code (optional)

.PARAMETER Callsign
Flight callsign (optional)
#>
function Get-FlightDataOpenSky {
    param(
        [string]$Icao24,
        [string]$Callsign
    )
    
    try {
        $baseURL = $global:APIConfig.OpenSky.BaseURL
        $endpoint = $global:APIConfig.OpenSky.FlightsEndpoint
        $uri = "$baseURL$endpoint"
        
        $response = Invoke-WebRequest -Uri $uri -TimeoutSec $global:DefaultSettings.TimeoutSeconds -UseBasicParsing -ErrorAction Stop
        $data = $response.Content | ConvertFrom-Json
        
        if ($data.states) {
            $flights = @()
            
            foreach ($state in $data.states) {
                # Handle optional fields (some may be null)
                $lastContact = if ($state[3]) { ([datetime]'1970-01-01').AddSeconds($state[3]) } else { $null }
                $flight = New-Object PSObject -Property @{
                    ICAO24 = [string]($state[0])
                    Callsign = if ($state[1]) { ($state[1] -replace '\s+$','').Trim() } else { "" }
                    Origin = $state[2]
                    LastContact = $lastContact
                    Latitude = $state[6]
                    Longitude = $state[5]
                    Altitude = if ($state[7] -ne $null) { [int]$state[7] } else { 0 }
                    OnGround = $state[8]
                    Velocity = if ($state[9] -ne $null) { [double]$state[9] } else { 0 }
                    TrueTrack = if ($state[10] -ne $null) { [double]$state[10] } else { 0 }
                    VerticalRate = if ($state[11] -ne $null) { [double]$state[11] } else { 0 }
                    Squawk = $state[14]
                    GeoAltitude = if ($state[13] -ne $null) { [int]$state[13] } else { 0 }
                }
                $flights += $flight
            }
            
            return $flights
        }
        else {
            return $null
        }
    }
    catch {
        Write-Error "Failed to fetch flight data: $_"
        return $null
    }
}

<#
.SYNOPSIS
Filters flight data by callsign

.PARAMETER Flights
Array of flight objects

.PARAMETER Callsign
Callsign to search for
#>
function Find-FlightByCallsign {
    param(
        [object[]]$Flights,
        [string]$Callsign
    )
    
    return $Flights | Where-Object { $_.Callsign -like "*$Callsign*" }
}

<#
.SYNOPSIS
Filters flight data by airline or country

.PARAMETER Flights
Array of flight objects

.PARAMETER Query
Text to search for
#>
function Find-FlightByQuery {
    param(
        [object[]]$Flights,
        [string]$Query
    )
    
    return $Flights | Where-Object { 
        $_.Callsign -like "*$Query*" -or 
        $_.Origin -like "*$Query*"
    }
}

<#
.SYNOPSIS
Formats flight data for display

.PARAMETER Flights
Array of flight objects

.PARAMETER Format
Output format: "Table", "JSON", or "List"
#>
function Format-FlightData {
    param(
        [object[]]$Flights,
        [string]$Format = "Table"
    )
    
    # Clear the format of null or empty results
    if (-not $Flights -or $Flights.Count -eq 0) {
        Write-Host "No flight data available." -ForegroundColor Yellow
        return
    }
    
    switch ($Format) {
        "Table" {
            $Flights | Select-Object @{Name="Callsign";Expression={$_.Callsign}},
                                      @{Name="ICAO24";Expression={$_.ICAO24}},
                                      @{Name="Altitude (ft)";Expression={$_.Altitude}},
                                      @{Name="Velocity (m/s)";Expression={$_.Velocity}},
                                      @{Name="Latitude";Expression={$_.Latitude}},
                                      @{Name="Longitude";Expression={$_.Longitude}},
                                      @{Name="On Ground";Expression={$_.OnGround}} |
            Format-Table -AutoSize
        }
        "JSON" {
            $Flights | ConvertTo-Json -Depth 10
        }
        "List" {
            foreach ($flight in $Flights) {
                Write-Host "========================================" -ForegroundColor Cyan
                Write-Host "Callsign: $($flight.Callsign)" -ForegroundColor Green
                Write-Host "ICAO24: $($flight.ICAO24)"
                Write-Host "Altitude: $($flight.Altitude) ft"
                Write-Host "Velocity: $($flight.Velocity) m/s"
                Write-Host "Position: $($flight.Latitude), $($flight.Longitude)"
                Write-Host "On Ground: $($flight.OnGround)"
                Write-Host "Last Contact: $($flight.LastContact)"
                Write-Host ""
            }
        }
    }
}

Export-ModuleMember -Function Get-FlightDataOpenSky, Find-FlightByCallsign, Find-FlightByQuery, Format-FlightData
