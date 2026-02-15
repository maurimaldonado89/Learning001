# Flight Status Checker
# A PowerShell application to check real-time flight statuses

param(
    [Parameter(Mandatory=$false)]
    [string]$Callsign,
    
    [Parameter(Mandatory=$false)]
    [string]$Query,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Table", "JSON", "List")]
    [string]$OutputFormat = "Table",
    
    [switch]$Interactive
)

# Import configuration and modules
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Definition
. "$scriptPath\config.ps1"
Import-Module "$scriptPath\modules\FlightAPI.psm1" -Force

function Show-MainMenu {
    Clear-Host
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host "  FLIGHT STATUS CHECKER - Main Menu" -ForegroundColor Cyan
    Write-Host "=========================================" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1. View all active flights worldwide" -ForegroundColor Green
    Write-Host "2. Search flights by callsign" -ForegroundColor Green
    Write-Host "3. Search flights by query" -ForegroundColor Green
    Write-Host "4. Change output format" -ForegroundColor Green
    Write-Host "5. Exit" -ForegroundColor Red
    Write-Host ""
}

function Show-OutputFormatMenu {
    Write-Host ""
    Write-Host "Select output format:" -ForegroundColor Cyan
    Write-Host "1. Table (default)" -ForegroundColor Green
    Write-Host "2. JSON" -ForegroundColor Green
    Write-Host "3. List" -ForegroundColor Green
    Write-Host ""
}

function Interactive-Mode {
    $continueLoop = $true
    
    while ($continueLoop) {
        Show-MainMenu
        $choice = Read-Host "Enter your choice (1-5)"
        
        switch ($choice) {
            "1" {
                Write-Host ""
                Write-Host "Fetching all active flights worldwide..." -ForegroundColor Yellow
                $flights = Get-FlightDataOpenSky
                Format-FlightData -Flights $flights -Format $global:DefaultSettings.OutputFormat
                Read-Host "Press Enter to continue"
            }
            "2" {
                Write-Host ""
                $callsign = Read-Host "Enter callsign to search (e.g., UAL, DAL, LOT)"
                Write-Host "Searching for flights with callsign: $callsign" -ForegroundColor Yellow
                $flights = Get-FlightDataOpenSky
                $results = Find-FlightByCallsign -Flights $flights -Callsign $callsign
                Format-FlightData -Flights $results -Format $global:DefaultSettings.OutputFormat
                Read-Host "Press Enter to continue"
            }
            "3" {
                Write-Host ""
                $query = Read-Host "Enter search query"
                Write-Host "Searching for: $query" -ForegroundColor Yellow
                $flights = Get-FlightDataOpenSky
                $results = Find-FlightByQuery -Flights $flights -Query $query
                Format-FlightData -Flights $results -Format $global:DefaultSettings.OutputFormat
                Read-Host "Press Enter to continue"
            }
            "4" {
                Show-OutputFormatMenu
                $formatChoice = Read-Host "Enter format choice (1-3)"
                switch ($formatChoice) {
                    "1" { $global:DefaultSettings.OutputFormat = "Table" }
                    "2" { $global:DefaultSettings.OutputFormat = "JSON" }
                    "3" { $global:DefaultSettings.OutputFormat = "List" }
                }
                Write-Host "Output format changed to: $($global:DefaultSettings.OutputFormat)" -ForegroundColor Green
                Read-Host "Press Enter to continue"
            }
            "5" {
                Write-Host ""
                Write-Host "Exiting Flight Status Checker. Goodbye!" -ForegroundColor Yellow
                $continueLoop = $false
            }
            default {
                Write-Host "Invalid choice. Please try again." -ForegroundColor Red
                Read-Host "Press Enter to continue"
            }
        }
    }
}

function CommandLine-Mode {
    Write-Host "Fetching flight data..." -ForegroundColor Yellow
    $flights = Get-FlightDataOpenSky
    
    if ($Callsign) {
        Write-Host "Searching for callsign: $Callsign" -ForegroundColor Cyan
        $flights = Find-FlightByCallsign -Flights $flights -Callsign $Callsign
    }
    elseif ($Query) {
        Write-Host "Searching for: $Query" -ForegroundColor Cyan
        $flights = Find-FlightByQuery -Flights $flights -Query $Query
    }
    
    Format-FlightData -Flights $flights -Format $OutputFormat
}

# Main execution
if ($Interactive -or (-not $Callsign -and -not $Query)) {
    Interactive-Mode
}
else {
    CommandLine-Mode
}
