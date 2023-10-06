import flask

import database
import utils
from models.actor import Actor
from models.movie import Movie

# Initialize the blueprint with CRUD endpoints for the Movie resource.
blueprint = flask.Blueprint("movies", __name__)


# $ curl --location --request GET 'http://127.0.0.1:5000/movies'
@blueprint.route("/", methods=["GET"])
def get_movies():
    # Initialize a default limit value. The limit value defines the quantity of
    # maximum allowable records we will retrieve from the database.
    # For instance, with a limit of 15, we will retrieve at most 15 records
    # from the database.
    limit = 10
    if "limit" in flask.request.args:
        limit = flask.request.args["limit"]

    # Retrieve movie records from the database.
    movies = database.db.session.query(Movie).order_by(Movie.id).limit(limit).all()
    # Convert the Movie database records (SQLAlchemy Objects) into a JSON
    # object response.
    return flask.jsonify(utils.serialize_sqlalchemy_objects_to_dictionary(movies))


# $ curl --location --request POST 'http://127.0.0.1:5000/movies' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "name": "Training Day",
#     "synopsis": "A blistering action drama that asks the audience to decide what is necessary, what is heroic and what crosses the line in the harrowing gray zone of fighting urban crime.",
#     "year": "2001",
#     "actor_ids": ["1", "4"]
# }'
@blueprint.route("/", methods=["POST"])
def create_movie():
    # Parse the JSON data in the request's body.
    movie_data = flask.request.get_json()

    # Validate that the client provided all required fields.
    required_fields = ["name", "synopsis", "year"]
    for field in required_fields:
        # If a required field is missing, return a 400 (Bad Request) HTTP
        # Status Code to clients, signifying that we received a bad request.
        if field not in movie_data:
            flask.abort(400, description=f"{field} can't be blank.")

    # Initialize and populate a Movie object with the data submitted by the client.
    movie = Movie()
    movie.name = movie_data["name"]
    movie.synopsis = movie_data["synopsis"]
    movie.year = int(movie_data["year"])

    # Associate any provided actors with the movie we would like to create.
    if "actor_ids" in movie_data:
        movie.actors = (
            database.db.session.query(Actor)
            .filter(Actor.id.in_(movie_data["actor_ids"]))
            .all()
        )

    # Add the Movie to the database and commit the transaction.
    database.db.session.add(movie)
    database.db.session.commit()

    # Convert the Movie database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(movie))


# $ curl --location --request GET 'http://127.0.0.1:5000/movies/1'
@blueprint.route("/<int:movie_id>", methods=["GET"])
def get_movie(movie_id):
    # Attempt to retrieve a Movie record with the client-provided Movie ID.
    movie = database.db.session.get(Movie, movie_id)
    # If we cannot find a Movie record with the Movie ID provided, return a 404
    # (Not Found) HTTP Status Code to clients, signifying that we did not find
    # the record.
    if not movie:
        flask.abort(404, description=f"Movie {movie_id} not found.")

    # Convert the Movie database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(movie))


# $ curl --location --request PATCH 'http://127.0.0.1:5000/movies/1' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "actor_ids": [5]
# }'
@blueprint.route("/<int:movie_id>", methods=["PATCH"])
def update_movie(movie_id):
    # Attempt to retrieve a Movie record with the client-provided Movie ID.
    movie = database.db.session.get(Movie, movie_id)
    # If we cannot find a Movie record with the Movie ID provided, return a 404
    # (Not Found) HTTP Status Code to clients, signifying that we did not find
    # the record.
    if not movie:
        flask.abort(404, description=f"Movie {movie_id} not found.")

    # Parse the JSON data in the request's body.
    movie_data = flask.request.get_json()
    if "name" in movie_data:
        movie.name = movie_data["name"]
    if "synopsis" in movie_data:
        movie.synopsis = movie_data["synopsis"]
    if "year" in movie_data:
        movie.year = movie_data["year"]
    # Associate any provided actors with the movie we would like to create.
    if "actor_ids" in movie_data:
        movie.actors = (
            database.db.session.query(Actor)
            .filter(Actor.id.in_(movie_data["actor_ids"]))
            .all()
        )

    # Commit the database changes.
    database.db.session.commit()

    # Convert the Movie database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(movie))


# $ curl --location --request DELETE 'http://127.0.0.1:5000/movies/1'
@blueprint.route("/<int:movie_id>", methods=["DELETE"])
def delete_movie(movie_id):
    # Attempt to retrieve a Movie record with the client-provided Movie ID.
    movie = database.db.session.get(Movie, movie_id)
    if not movie:
        # If we cannot find a Movie record with the Movie ID provided, return a 404
        # (Not Found) HTTP Status Code to clients, signifying that we did not find
        # the record.
        flask.abort(404, description=f"Movie {movie_id} not found.")

    # Remove the Movie from the database and commit the transaction.
    database.db.session.delete(movie)
    database.db.session.commit()

    # Convert the Movie database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(movie))
