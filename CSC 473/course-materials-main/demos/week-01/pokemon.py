import typing

import requests


def get_pokemon_details(pokemon_name: str):
    return requests.get(f"https://pokeapi.co/api/v2/pokemon/{pokemon_name}").json()


if __name__ == "__main__":
    pokemon_details = get_pokemon_details(pokemon_name="charizard")
    print(pokemon_details)
