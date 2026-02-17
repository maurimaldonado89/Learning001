# Pokemon Information Lookup Tool

A PowerShell application that retrieves detailed Pokemon information from the [PokeAPI](https://pokeapi.co/) based on Pokemon name or ID number.

## Prerequisites

- PowerShell 5.1 or higher
- Internet connection (to access PokeAPI)
- No additional modules required (uses built-in `Invoke-RestMethod`)

<<<<<<< HEAD
## Installation

1. Clone or download the repository:
   ```powershell
   cd c:\Users\1020767\Learning001
   ```

2. The script is ready to use: `Get-PokemonInfo.ps1`

## Usage

### 1. Lookup by Pokemon Name
```powershell
.\Get-PokemonInfo.ps1 -Pokemon "pikachu"
.\Get-PokemonInfo.ps1 -Pokemon "charizard"
```

### 2. Lookup by Pokemon ID Number
```powershell
.\Get-PokemonInfo.ps1 -Pokemon 25
.\Get-PokemonInfo.ps1 -Pokemon 6
```

### 3. List First 50 Pokemon
```powershell
.\Get-PokemonInfo.ps1 -All
```

### 4. Interactive Mode
Run without parameters to enter interactive mode:
```powershell
.\Get-PokemonInfo.ps1
```

In interactive mode, you can:
- Enter any Pokemon name or ID
- Type `list` to see the first 50 Pokemon
- Type `exit` or `quit` to close the application
- Press `Ctrl+C` to exit anytime

## Example Output

```
========================================
ID                   : 25
Name                 : PIKACHU
Type(s)              : electric
Height (dm)          : 4
Weight (hg)          : 60
Abilities            : static, lightning-rod
Base Stats           : hp: 35 | attack: 55 | defense: 40 | special-attack: 50 | special-defense: 50 | speed: 90
========================================
```

## Features

- **Query by Name or ID**: Use Pokemon names (case-insensitive) or ID numbers
- **Comprehensive Data**: Displays type, height, weight, abilities, and base stats
- **Error Handling**: Gracefully handles invalid Pokemon names/IDs with helpful messages
- **Interactive Mode**: Explore Pokemon at your own pace
- **Formatted Output**: Color-coded terminal output for easy reading
- **Verbose Logging**: Optional detailed API call information with `-Verbose` flag

## API Information

This script uses the free **PokeAPI v2** endpoint:
- Base URL: `https://pokeapi.co/api/v2`
- Endpoints used:
  - `/pokemon/{id_or_name}` - Get Pokemon details
  - `/pokemon?limit=X&offset=Y` - List Pokemon

No API key required. Rate limiting is in place but generous for public use.

## Troubleshooting

### "Invalid PowerShell execution policy" error
Run PowerShell as Administrator and execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### "Pokemon not found" error
- Check spelling of the Pokemon name (names are case-insensitive)
- Verify the ID number is between 1 and ~1025
- Some newer Pokemon may not be in the API yet

### API Connection Issues
- Verify your internet connection
- Check if PokeAPI is accessible: `https://pokeapi.co/api/v2/pokemon/1`
- The API may be temporarily unavailable

## Script Features

- **Parameter Validation**: Accepts both string names and integer IDs
- **Pipeline Support**: Can accept input via pipeline
- **Help Documentation**: Run `Get-Help .\Get-PokemonInfo.ps1 -Full` for complete help
- **Verbose Output**: Add `-Verbose` flag for detailed execution information

## Example Workflows

### Quick Lookup
```powershell
.\Get-PokemonInfo.ps1 -Pokemon bulbasaur
```

### Check Multiple Pokemon
```powershell
"pikachu", "charizard", "blastoise" | ForEach-Object { .\Get-PokemonInfo.ps1 -Pokemon $_ }
```

### Verbose Mode
```powershell
.\Get-PokemonInfo.ps1 -Pokemon 1 -Verbose
```

## Project Structure

```
Learning001/
├── Get-PokemonInfo.ps1  (Main script)
└── README.md            (This file)
```

## Future Enhancements

- Export results to CSV/JSON
- Search by type
- Compare base stats between Pokemon
- Display evolution chains
- Caching for frequently searched Pokemon

## License

This project uses data from [PokeAPI](https://pokeapi.co/), which is available under CC0 1.0 Universal Public Domain.

## Support

For issues or questions:
1. Verify the Pokemon name/ID is correct
2. Check your internet connection
3. Review error messages for hints
4. Test with a known Pokemon (e.g., "pikachu" or ID "25")

---

**Last Updated**: February 15, 2026  
**PowerShell Version**: 5.1+  
**API**: PokeAPI v2
=======
This is the Description of the readme file
on github
This is the Description of the readme file Testtt
>>>>>>> 021d4048ba7b53dc4584b79f7d0a71e68e1a3099
