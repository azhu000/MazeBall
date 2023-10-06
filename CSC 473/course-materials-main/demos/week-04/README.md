👋 Hi, there!

Welcome to our IMDB API.

The IMDB API intends to serve as an application that introduces you to various aspects of building an API, including but not limited to Databases, HTTP, JSON, and Testing (Integration, Unit).


# Running the Application

1. Set Python Version
```
pyenv local 3.10.6
```

2. Create Virtual Environment
```
pyenv virtualenv venv-week-04
```

3. Activate Virtual Environment
```
pyenv activate venv-week-04
```

4. Install Project Dependencies
```
pip install -r requirements.txt
```

5. Run Application
```
python app.py
```

# Callouts
1. Why are we using SQLite and not PostgreSQL?

We're using SQLite instead of PostgreSQL to minimize the overhead of running this application locally. By using SQLite, we only have to worry about having Python & SQLite installed, both of which should come preinstalled for most platforms.

2. Where can I find API Requests to test?

I included example CURL requests in line.
