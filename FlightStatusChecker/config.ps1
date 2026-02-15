# Flight Status Checker Configuration
# =============================================

# API Configuration
$global:APIConfig = @{
    # OpenSky Network API (Free, no authentication required)
    OpenSky = @{
        BaseURL = "https://opensky-network.org/api"
        FlightsEndpoint = "/states/all"
        AircraftEndpoint = "/states/all"
    }
    
    # AviationStack API (Requires free API key)
    AviationStack = @{
        BaseURL = "http://api.aviationstack.com/v1"
        FlightsEndpoint = "/flights"
        ApiKey = ""  # Add your free API key from aviationstack.com
    }
}

# Default settings
$global:DefaultSettings = @{
    TimeoutSeconds = 10
    UseAPI = "OpenSky"  # Change to "AviationStack" if you have an API key
    OutputFormat = "Table"  # Options: "Table", "JSON", "List"
}
