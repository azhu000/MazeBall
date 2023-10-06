import datetime

import flask

import database
import utils
from models.actor import Actor

# Initialize the blueprint with CRUD endpoints for the Actor resource.
blueprint = flask.Blueprint("actors", __name__)


# $ curl --location --request GET 'http://127.0.0.1:5000/actors'
@blueprint.route("/", methods=["GET"])
def get_actors():
    # Initialize a default limit value. The limit value defines the quantity of
    # maximum allowable records we will retrieve from the database.
    # For instance, with a limit of 15, we will retrieve at most 15 records
    # from the database.
    limit = 10
    if "limit" in flask.request.args:
        limit = flask.request.args["limit"]

    # Retrieve actor records from the database.
    actors = database.db.session.query(Actor).order_by(Actor.id).limit(limit).all()
    # Convert the Actor database records (SQLAlchemy Objects) into a JSON
    # object response.
    return flask.jsonify(utils.serialize_sqlalchemy_objects_to_dictionary(actors))


# The 25 Greatest Actors of the 21st Century.
# https://www.nytimes.com/interactive/2020/movies/greatest-actors-actresses.html


# $ curl --location --request POST 'http://127.0.0.1:5000/actors' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "first_name": "Denzel",
#     "last_name": "Washington",
#     "date_of_birth": "12/28/1954",
#     "biography": "Denzel Hayes Washington Jr. is an American actor and filmmaker."
# }'
# $ curl --location --request POST 'http://127.0.0.1:5000/actors' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "first_name": "Isabelle",
#     "last_name": "Huppert",
#     "date_of_birth": "03/16/1953",
#     "biography": "Isabelle Anne Madeleine Huppert is a French actress."
# }'
# $ curl --location --request POST 'http://127.0.0.1:5000/actors' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "first_name": "Daniel",
#     "last_name": "Day-Lewis",
#     "date_of_birth": "04/29/1957",
#     "biography": "Sir Daniel Michael Blake Day-Lewis is an English retired actor."
# }'
# $ curl --location --request POST 'http://127.0.0.1:5000/actors' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "first_name": "Snoop",
#     "last_name": "Dogg",
#     "date_of_birth": "10/20/1971",
#     "biography": "Calvin Cordozar Broadus Jr., known professionally as Snoop Dogg, is an American rapper."
# }'
@blueprint.route("/", methods=["POST"])
def create_actor():
    # Parse the JSON data in the request's body.
    actor_data = flask.request.get_json()

    # Validate that the client provided all required fields.
    required_fields = ["first_name", "last_name", "date_of_birth"]
    for field in required_fields:
        # If a required field is missing, return a 400 (Bad Request) HTTP
        # Status Code to clients, signifying that we received a bad request.
        if field not in actor_data:
            flask.abort(400, description=f"{field} cannot be blank.")

    # Initialize and populate a Actor object with the data submitted by the client.
    actor = Actor()
    actor.first_name = actor_data["first_name"]
    actor.last_name = actor_data["last_name"]
    actor.date_of_birth = datetime.datetime.strptime(
        actor_data["date_of_birth"], "%m/%d/%Y"
    ).date()
    actor.biography = actor_data.get("biography")

    # Add the Actor to the database and commit the transaction.
    database.db.session.add(actor)
    database.db.session.commit()

    # Convert the Actor database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(actor))


# $ curl --location --request GET 'http://127.0.0.1:5000/actors/1'
@blueprint.route("/<int:actor_id>", methods=["GET"])
def get_actor(actor_id):
    # Attempt to retrieve a Actor record with the client-provided Actor ID.
    actor = database.db.session.get(Actor, actor_id)
    # If we cannot find a Actor record with the Actor ID provided, return a 404
    # (Not Found) HTTP Status Code to clients, signifying that we did not find
    # the record.
    if not actor:
        flask.abort(404, description=f"Actor {actor_id} not found.")

    # Convert the Actor database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(actor))


# $ curl --location --request PATCH 'http://127.0.0.1:5000/actors/1' \
# --header 'Content-Type: application/json' \
# --data-raw '{
#     "first_name": "Alonzo",
#     "last_name": "Harris"
# }'
@blueprint.route("/<int:actor_id>", methods=["PATCH"])
def update_actor(actor_id):
    # Attempt to retrieve a Actor record with the client-provided Actor ID.
    actor = database.db.session.get(Actor, actor_id)
    # If we cannot find a Actor record with the Actor ID provided, return a 404
    # (Not Found) HTTP Status Code to clients, signifying that we did not find
    # the record.
    if not actor:
        flask.abort(404, description=f"Actor {actor_id} not found.")

    # Parse the JSON data in the request's body.
    actor_data = flask.request.get_json()
    if "first_name" in actor_data:
        actor.first_name = actor_data["first_name"]
    if "last_name" in actor_data:
        actor.last_name = actor_data["last_name"]
    if "date_of_birth" in actor_data:
        actor.date_of_birth = datetime.datetime.strptime(
            actor_data["date_of_birth"], "%m/%d/%Y"
        ).date()
    if "biography" in actor_data:
        actor.biography = actor_data["biography"]

    # Commit the database changes.
    database.db.session.commit()

    # Convert the Actor database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(actor))


# $ curl --location --request DELETE 'http://127.0.0.1:5000/actors/1'
@blueprint.route("/<int:actor_id>", methods=["DELETE"])
def delete_actor(actor_id):
    # Attempt to retrieve a Actor record with the client-provided Actor ID.
    actor = database.db.session.get(Actor, actor_id)
    if not actor:
        # If we cannot find a Actor record with the Actor ID provided, return a 404
        # (Not Found) HTTP Status Code to clients, signifying that we did not find
        # the record.
        flask.abort(404, description=f"Actor {actor_id} not found.")

    # Remove the Actor from the database and commit the transaction.
    database.db.session.delete(actor)
    database.db.session.commit()

    # Convert the Actor database record (SQLAlchemy Object) into a JSON object response.
    return flask.jsonify(utils.serialize_sqlalchemy_object_to_dictionary(actor))
