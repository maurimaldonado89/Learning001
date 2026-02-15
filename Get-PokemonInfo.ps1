#Requires -Version 5.1
<#
.SYNOPSIS
    Get Pokemon information by name or number ID.

.DESCRIPTION
    Queries the PokeAPI (https://pokeapi.co/) to retrieve Pokemon information
    including type, abilities, height, weight, and base stats.

.PARAMETER Pokemon
    The name or ID number of the Pokemon to look up.

.PARAMETER All
    Switch to display all Pokemon (limited to first 50 for performance).

.EXAMPLE
    .\Get-PokemonInfo.ps1 -Pokemon "pikachu"
    .\Get-PokemonInfo.ps1 -Pokemon 25
    .\Get-PokemonInfo.ps1 -All

.NOTES
    Requires internet connection for API access.
    Pokemon names are case-insensitive.
#>

param(
    [Parameter(ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [string]$Pokemon,
    
    [switch]$All
)

$ErrorActionPreference = 'Stop'
$ApiBaseUrl = 'https://pokeapi.co/api/v2'

function Get-PokemonData {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [string]$Identifier
    )
    
    try {
        $Identifier = $Identifier.ToLower().Trim()
        $uri = "$ApiBaseUrl/pokemon/$Identifier"
        
        Write-Verbose "Querying: $uri"
        $response = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
        return $response
    }
    catch {
        if ($_.Exception.Response.StatusCode -eq 'NotFound') {
            Write-Error "Pokemon '$Identifier' not found. Please check the name or ID and try again."
        }
        else {
            Write-Error "Failed to retrieve Pokemon data: $_"
        }
        return $null
    }
}

function Format-PokemonInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        [PSObject]$PokemonData
    )
    
    $types = $PokemonData.types | ForEach-Object { $_.type.name }
    $abilities = $PokemonData.abilities | ForEach-Object { $_.ability.name }
    $stats = @()
    
    foreach ($stat in $PokemonData.stats) {
        $stats += "$($stat.stat.name): $($stat.base_stat)"
    }
    
    $output = @{
        'ID'           = $PokemonData.id
        'Name'         = $PokemonData.name.ToUpper()
        'Type(s)'      = ($types -join ', ')
        'Height (dm)'  = $PokemonData.height
        'Weight (hg)'  = $PokemonData.weight
        'Abilities'    = ($abilities -join ', ')
        'Base Stats'   = ($stats -join ' | ')
    }
    
    return $output
}

function Display-PokemonInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]$PokemonInfo
    )
    
    Write-Host "`n" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    foreach ($key in @('ID', 'Name', 'Type(s)', 'Height (dm)', 'Weight (hg)', 'Abilities', 'Base Stats')) {
        Write-Host ("{0,-20} : {1}" -f $key, $PokemonInfo[$key]) -ForegroundColor Green
    }
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host ""
}

function Get-AllPokemon {
    [CmdletBinding()]
    param(
        [int]$Limit = 50
    )
    
    try {
        Write-Host "Fetching first $Limit Pokemon..." -ForegroundColor Yellow
        $uri = "$ApiBaseUrl/pokemon?limit=$Limit&offset=0"
        $response = Invoke-RestMethod -Uri $uri -Method Get -ErrorAction Stop
        
        $total = $response.count
        Write-Host "Found $total total Pokemon. Displaying first ${Limit}:" -ForegroundColor Cyan
        Write-Host ""
        
        $response.results | ForEach-Object {
            Write-Host "$($_.name.PadRight(20)) - $($_.url.Split('/')[-2])" -ForegroundColor Green
        }
        
        Write-Host "`nTo get detailed info, run: .\Get-PokemonInfo.ps1 -Pokemon <name_or_number>" -ForegroundColor Yellow
    }
    catch {
        Write-Error "Failed to fetch Pokemon list: $_"
    }
}

# Main execution
if ($All) {
    Get-AllPokemon
}
elseif ([string]::IsNullOrWhiteSpace($Pokemon)) {
    # Interactive mode
    Write-Host "=== Pokemon Information Lookup ===" -ForegroundColor Cyan
    Write-Host "Enter 'list' to see first 50 Pokemon, or press Ctrl+C to exit.`n" -ForegroundColor Yellow
    
    while ($true) {
        $userInput = Read-Host "Enter Pokemon name or ID"
        
        if ([string]::IsNullOrWhiteSpace($userInput)) {
            continue
        }
        
        if ($userInput.ToLower() -eq 'list') {
            Get-AllPokemon
            continue
        }
        
        if ($userInput.ToLower() -eq 'exit' -or $userInput.ToLower() -eq 'quit') {
            break
        }
        
        $data = Get-PokemonData -Identifier $userInput
        if ($data) {
            $formatted = Format-PokemonInfo -PokemonData $data
            Display-PokemonInfo -PokemonInfo $formatted
        }
    }
}
else {
    # Direct lookup
    $data = Get-PokemonData -Identifier $Pokemon
    if ($data) {
        $formatted = Format-PokemonInfo -PokemonData $data
        Display-PokemonInfo -PokemonInfo $formatted
    }
}
