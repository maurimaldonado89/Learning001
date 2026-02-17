# Pokemon Information REST API

A REST API server for Pokemon information using PokeAPI v2 data.

## Installation & Setup

### Prerequisites
- Python 3.8 or higher
- Windows/Linux/macOS

### Step 1: Install Python Dependencies

```powershell
cd c:\Users\1020767\Learning001
pip install -r requirements.txt
```

### Step 2: Run the Server

```powershell
python pokemon_api.py
```

You should see:
```
 * Running on http://localhost:5000
 * Debug mode: on
```

## API Endpoints

### 1. Get Pokemon Information

**Endpoint:** `GET /pokemon/<name_or_id>`

**Examples:**
```bash
# By name (case-insensitive)
curl http://localhost:5000/pokemon/pikachu

# By ID
curl http://localhost:5000/pokemon/25
```

**Response:**
```json
{
  "id": 25,
  "name": "PIKACHU",
  "types": ["electric"],
  "height": 4,
  "weight": 60,
  "abilities": [
    {
      "name": "static",
      "hidden": false
    },
    {
      "name": "lightning-rod",
      "hidden": false
    }
  ],
  "base_stats": {
    "hp": 35,
    "attack": 55,
    "defense": 40,
    "special-attack": 50,
    "special-defense": 50,
    "speed": 90
  },
  "sprites": {
    "front": "https://raw.githubusercontent.com/PokeAPI/sprites/master/pokemon/25.png",
    "back": "https://raw.githubusercontent.com/PokeAPI/sprites/master/pokemon/back/25.png"
  }
}
```

### 2. List Pokemon

**Endpoint:** `GET /pokemon/list`

**Query Parameters:**
- `limit`: Number of results (default: 50, max: 1000)
- `offset`: Starting position (default: 0)

**Examples:**
```bash
# Get first 20 Pokemon
curl http://localhost:5000/pokemon/list?limit=20

# Get Pokemon 50-100
curl http://localhost:5000/pokemon/list?limit=50&offset=50
```

**Response:**
```json
{
  "count": 1025,
  "next": "https://pokeapi.co/api/v2/pokemon?limit=50&offset=50",
  "previous": null,
  "results": [
    {
      "name": "BULBASAUR",
      "url": "https://pokeapi.co/api/v2/pokemon/1/"
    },
    {
      "name": "IVYSAUR",
      "url": "https://pokeapi.co/api/v2/pokemon/2/"
    }
    // ... more Pokemon
  ]
}
```

### 3. Health Check

**Endpoint:** `GET /health`

Returns API status.

### 4. API Documentation

**Endpoint:** `GET /`

Returns available endpoints and usage examples.

## Testing the API

### Using PowerShell

```powershell
# Get Pokemon by name
Invoke-RestMethod -Uri "http://localhost:5000/pokemon/pikachu" | Format-Table

# Get Pokemon by ID
Invoke-RestMethod -Uri "http://localhost:5000/pokemon/25" | Format-Table

# List first 20 Pokemon
Invoke-RestMethod -Uri "http://localhost:5000/pokemon/list?limit=20" | Select-Object -ExpandProperty results
```

### Using Python

```python
import requests

# Get Pokemon
response = requests.get("http://localhost:5000/pokemon/charizard")
print(response.json())

# List Pokemon
response = requests.get("http://localhost:5000/pokemon/list?limit=10")
print(response.json())
```

### Using JavaScript/Web Browser

```javascript
// Get Pokemon
fetch('/pokemon/dragonite')
  .then(res => res.json())
  .then(data => console.log(data));

// List Pokemon
fetch('/pokemon/list?limit=30')
  .then(res => res.json())
  .then(data => console.log(data.results));
```

## Production Deployment

### Using Gunicorn (Linux/macOS)

```bash
gunicorn --workers 4 --bind 0.0.0.0:5000 pokemon_api:app
```

### Using Windows Service

1. Install NSSM (Non-Sucking Service Manager):
   ```powershell
   choco install nssm
   ```

2. Create service:
   ```powershell
   nssm install PokemonAPI "C:\python\python.exe" "c:\Users\1020767\Learning001\pokemon_api.py"
   nssm start PokemonAPI
   ```

### Docker Deployment

Create `Dockerfile`:
```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt
COPY pokemon_api.py .
CMD ["python", "pokemon_api.py"]
EXPOSE 5000
```

Build and run:
```bash
docker build -t pokemon-api .
docker run -p 5000:5000 pokemon-api
```

## Error Handling

| Status Code | Meaning |
|-------------|---------|
| 200 | Success |
| 404 | Pokemon not found |
| 500 | Internal server error |
| 503 | PokeAPI temporarily unavailable |
| 504 | API request timeout |

## CORS Support

The API supports Cross-Origin Resource Sharing (CORS), so you can call it from web applications on different domains.

## Troubleshooting

### Import Error: No module named 'flask'
```powershell
pip install -r requirements.txt
```

### Port 5000 already in use
Either:
1. Kill the process using port 5000
2. Edit `pokemon_api.py` line and change `port=5000` to another port

### PokeAPI is slow or unavailable
- The free PokeAPI has rate limits but they're generous
- Check internet connection
- Try again in a few moments

## Future Enhancements

- Search Pokemon by type
- Compare stats between Pokemon
- Get evolution chains
- Caching layer for performance
- Database integration
- Authentication/rate limiting

---

**Last Updated:** February 17, 2026  
**API Framework:** Flask  
**Base API:** PokeAPI v2
