from sqlalchemy import Column, ForeignKey

from database import db

MovieActor = db.Table(
    "movie_actors",
    Column("actor_id", ForeignKey("actors.id"), primary_key=True),
    Column("movie_id", ForeignKey("movies.id"), primary_key=True),
)
