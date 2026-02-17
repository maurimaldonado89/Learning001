"""
Pokemon Information REST API
Wraps PokeAPI v2 and serves Pokemon data via HTTP
"""

from flask import Flask, request, jsonify
from flask_cors import CORS
import requests
from typing import Union, Dict, Any
import logging

app = Flask(__name__)
CORS(app)  # Enable cross-origin requests for web browsers

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# PokeAPI base URL
POKEAPI_BASE = "https://pokeapi.co/api/v2"


class PokemonAPI:
    """Handles Pokemon API queries"""
    
    @staticmethod
    def get_pokemon(pokemon_id: Union[str, int]) -> Dict[str, Any]:
        """
        Fetch Pokemon data from PokeAPI
        
        Args:
            pokemon_id: Pokemon name or ID number
            
        Returns:
            Dictionary with Pokemon data or error
        """
        try:
            url = f"{POKEAPI_BASE}/pokemon/{str(pokemon_id).lower()}"
            response = requests.get(url, timeout=5)
            
            if response.status_code == 404:
                return {"error": f"Pokemon '{pokemon_id}' not found", "status": 404}
            
            response.raise_for_status()
            data = response.json()
            
            return {
                "id": data.get("id"),
                "name": data.get("name", "").upper(),
                "types": [t["type"]["name"] for t in data.get("types", [])],
                "height": data.get("height"),  # in decimeters
                "weight": data.get("weight"),  # in hectograms
                "abilities": [
                    {"name": a["ability"]["name"], "hidden": a.get("is_hidden", False)}
                    for a in data.get("abilities", [])
                ],
                "base_stats": {
                    stat["stat"]["name"]: stat["base_stat"]
                    for stat in data.get("stats", [])
                },
                "sprites": {
                    "front": data.get("sprites", {}).get("front_default"),
                    "back": data.get("sprites", {}).get("back_default")
                }
            }
            
        except requests.exceptions.Timeout:
            return {"error": "API request timed out", "status": 504}
        except requests.exceptions.RequestException as e:
            logger.error(f"API error: {e}")
            return {"error": "Failed to reach Pokemon API", "status": 503}
    
    @staticmethod
    def list_pokemon(limit: int = 50, offset: int = 0) -> Dict[str, Any]:
        """
        List Pokemon with pagination
        
        Args:
            limit: Number of Pokemon to return (default 50)
            offset: Starting position (default 0)
            
        Returns:
            Dictionary with Pokemon list
        """
        try:
            # Limit the limit to reasonable values
            limit = min(max(1, limit), 1000)
            offset = max(0, offset)
            
            url = f"{POKEAPI_BASE}/pokemon?limit={limit}&offset={offset}"
            response = requests.get(url, timeout=5)
            response.raise_for_status()
            
            data = response.json()
            
            return {
                "count": data.get("count"),
                "next": data.get("next"),
                "previous": data.get("previous"),
                "results": [
                    {
                        "name": p["name"].upper(),
                        "url": p["url"]
                    }
                    for p in data.get("results", [])
                ]
            }
            
        except requests.exceptions.RequestException as e:
            logger.error(f"API error: {e}")
            return {"error": "Failed to fetch Pokemon list", "status": 503}


# Routes

@app.route("/", methods=["GET"])
def index():
    """API documentation and usage"""
    return jsonify({
        "name": "Pokemon Information API",
        "version": "1.0.0",
        "description": "REST API for Pokemon lookup from PokeAPI v2",
        "endpoints": {
            "GET /pokemon/<name_or_id>": "Get Pokemon by name or ID",
            "GET /pokemon/list": "List Pokemon (supports ?limit=50&offset=0)",
            "GET /health": "Health check"
        },
        "examples": {
            "lookup": "/pokemon/pikachu or /pokemon/25",
            "list": "/pokemon/list?limit=20&offset=0"
        }
    }), 200


@app.route("/health", methods=["GET"])
def health_check():
    """Health check endpoint"""
    return jsonify({"status": "healthy"}), 200


@app.route("/pokemon/<identifier>", methods=["GET"])
def get_pokemon(identifier):
    """
    Get Pokemon information by name or ID
    
    Usage:
        GET /pokemon/pikachu
        GET /pokemon/25
    """
    logger.info(f"Pokemon lookup: {identifier}")
    result = PokemonAPI.get_pokemon(identifier)
    
    status_code = result.pop("status", 200)
    return jsonify(result), status_code


@app.route("/pokemon/list", methods=["GET"])
def list_pokemon():
    """
    List Pokemon with pagination
    
    Query parameters:
        limit: Number of results (default 50, max 1000)
        offset: Starting position (default 0)
    """
    limit = request.args.get("limit", 50, type=int)
    offset = request.args.get("offset", 0, type=int)
    
    logger.info(f"Pokemon list: limit={limit}, offset={offset}")
    result = PokemonAPI.list_pokemon(limit, offset)
    
    status_code = result.pop("status", 200) if "error" in result else 200
    return jsonify(result), status_code


@app.errorhandler(404)
def not_found(error):
    """Handle 404 errors"""
    return jsonify({"error": "Endpoint not found", "status": 404}), 404


@app.errorhandler(500)
def internal_error(error):
    """Handle 500 errors"""
    logger.error(f"Internal error: {error}")
    return jsonify({"error": "Internal server error", "status": 500}), 500


if __name__ == "__main__":
    import os
    port = int(os.environ.get('PORT', 8000))
    print("Starting Pokemon Information API...")
    print(f"Server running at port {port}")
    app.run(debug=False, host="0.0.0.0", port=port)
