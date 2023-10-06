import typing

from sqlalchemy import Column, Date, Integer, String, Text
from sqlalchemy.orm import relationship

from database import db
from models.movie_actor import MovieActor


class Actor(db.Model):
    """
    Define a model/resource representing an Actor.
    """

    # Define the table name where we will store data.
    __tablename__ = "actors"

    # The unique identifier for each Actor record.
    id = Column(Integer, primary_key=True, autoincrement=True)

    first_name = Column(String, nullable=False)
    middle_name = Column(String)
    last_name = Column(String, nullable=False)

    biography = Column(Text)
    date_of_birth = Column(Date, nullable=False)

    # Establish a many-to-many relationship between Actors and Movies through
    # the MovieActor join table.
    movies = relationship("Movie", secondary=MovieActor, back_populates="actors")

    def full_name(self) -> typing.Text:
        """Construct and return the Actor's full name."""
        full_name_segments = []

        for segment in [self.first_name, self.middle_name, self.last_name]:
            if not segment:
                continue

            full_name_segments.append(segment)

        return " ".join(full_name_segments)

    def __repr__(self):
        return f"<User {self.full_name}>"
