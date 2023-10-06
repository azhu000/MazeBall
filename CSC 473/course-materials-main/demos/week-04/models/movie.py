from sqlalchemy import Column, Integer, String, Text
from sqlalchemy.orm import relationship

from database import db
from models.movie_actor import MovieActor


class Movie(db.Model):
    """
    Define a model/resource representing a Movie.
    """

    # Define the table name where we will store data.
    __tablename__ = "movies"

    # The unique identifier for each Movie record.
    id = Column(Integer, primary_key=True, autoincrement=True)

    name = Column(String, nullable=False)
    synopsis = Column(Text, nullable=False)
    year = Column(Integer, nullable=False)

    # Establish a many-to-many relationship between Actors and Movies through
    # the MovieActor join table.
    actors = relationship("Actor", secondary=MovieActor, back_populates="movies")

    def __repr__(self):
        return f"<Movie {self.name}>"
