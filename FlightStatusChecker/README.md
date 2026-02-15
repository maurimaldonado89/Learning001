# Flight Status Checker

A PowerShell application to check real-time flight statuses using the OpenSky Network API.

## Features

- ✈️ View all active flights worldwide in real-time
- 🔍 Search flights by callsign (e.g., UAL, DAL, LOT)
- 📍 Get flight position, altitude, velocity, and more
- 📊 Multiple output formats (Table, JSON, List)
- 🎯 Interactive menu mode for easy navigation
- ⚡ Command-line mode for automation

## Requirements

- PowerShell 5.0 or higher
- Internet connection
- No API key required (uses free OpenSky Network API)

## Installation

1. Navigate to the FlightStatusChecker directory:
```powershell
cd c:\Users\1020767\Learning001\FlightStatusChecker
```

2. Run the script (may need to set execution policy):
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

## Usage

### Interactive Mode (Default)

Run the script without parameters for interactive menu:

```powershell
.\FlightStatusChecker.ps1
```

Or explicitly:

```powershell
.\FlightStatusChecker.ps1 -Interactive
```

### Command-Line Mode

Search by callsign:
```powershell
.\FlightStatusChecker.ps1 -Callsign "UAL"
```

Search by query:
```powershell
.\FlightStatusChecker.ps1 -Query "United"
```

Specify output format:
```powershell
.\FlightStatusChecker.ps1 -Callsign "DAL" -OutputFormat "JSON"
```

## Output Formats

- **Table**: Displays flights in a formatted table (default)
- **JSON**: Outputs raw JSON data for parsing
- **List**: Displays detailed flight information in list format

## Flight Data Fields

- **Callsign**: Flight identification (e.g., UAL123)
- **ICAO24**: Aircraft hexadecimal code
- **Altitude**: Current altitude in feet
- **Velocity**: Current velocity in meters per second
- **Latitude/Longitude**: Current GPS position
- **On Ground**: Whether aircraft is on the ground
- **Last Contact**: Last time data was received

## Data Source

**OpenSky Network**
- Free real-time flight tracking data
- No authentication required
- Coverage varies by region (better in Europe, North America)
- Website: https://opensky-network.org

## Limitations

- Data updates may have slight delays
- Not all aircraft are tracked (depends on ADS-B coverage)
- Requires internet connection
- Free API may have rate limiting

## Alternative APIs

To use AviationStack or FlightAware (requires paid API keys):

1. Sign up at the API provider
2. Update your API keys in `config.ps1`
3. Modify the main script to use the alternative API

## Troubleshooting

**Error: "PowerShell execution policy"**
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**No flights returned**
- Check internet connection
- OpenSky may have sparse data in certain regions
- Try searching with just a country code (e.g., "US")

**Timeout errors**
- Increase timeout in `config.ps1`
- Check your network connection

## Author Notes

This application demonstrates:
- PowerShell modules
- REST API consumption
- Interactive CLI applications
- Error handling
- Function composition

## License

Free to use and modify for personal/educational purposes.
