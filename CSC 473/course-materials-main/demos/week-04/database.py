import flask_sqlalchemy

# We are opting to use the Flask SQLAlchemy library in favor of the SQLAlchemy
# library because the former provides an extension class consistent with how
# we construct our application in app.py.
db = flask_sqlalchemy.SQLAlchemy()
