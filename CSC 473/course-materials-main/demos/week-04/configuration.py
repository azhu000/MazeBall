import os

# Store a reference to the absolute path of the application's home directory.
base_directory = os.path.abspath(os.path.dirname(__file__))


class Configuration:
    """
    Configuration is a base class that we intend to inherit when creating
    configurations.
    """

    pass


class ConfigurationName:
    """
    ConfigurationName enumerates the various configuration environments.
    """

    DEVELOPMENT = "development"
    PRODUCTION = "production"
    TESTING = "testing"


class DevelopmentConfiguration(Configuration):
    # For additional details about debug mode please check the following:
    # https://flask.palletsprojects.com/en/2.2.x/config/
    DEBUG = True

    # The database connection URI.
    # For additional details please check the following:
    # https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/config/
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        "DEV_DATABASE_URL"
    ) or "sqlite:///" + os.path.join(base_directory, "imdb-dev.db")


class ProductionConfiguration(Configuration):
    # The database connection URI.
    # For additional details please check the following:
    # https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/config/
    SQLALCHEMY_DATABASE_URI = os.environ.get(
        "DATABASE_URL"
    ) or "sqlite:///" + os.path.join(base_directory, "imdb.db")


class TestingConfiguration(Configuration):
    # The database connection URI.
    # For additional details please check the following:
    # https://flask-sqlalchemy.palletsprojects.com/en/3.0.x/config/
    SQLALCHEMY_DATABASE_URI = os.environ.get("TEST_DATABASE_URL") or "sqlite:///"
    # Enable testing mode.Exceptions are propagated rather than handled by the
    # application error handlers.
    # For additional details please check the following:
    # https://flask.palletsprojects.com/en/2.2.x/config/
    TESTING = True
    # Disable all CSRF protection.
    WTF_CSRF_ENABLED = False


# Establish a mapping between configuration names and configuration classes.
configuration = {
    ConfigurationName.DEVELOPMENT: DevelopmentConfiguration,
    ConfigurationName.PRODUCTION: ProductionConfiguration,
    ConfigurationName.TESTING: TestingConfiguration,
}
