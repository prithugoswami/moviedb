from flask import Flask, session, g
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os

db = SQLAlchemy()

def create_app():
    app = Flask(__name__)

    # Set the db_url variable or else it will read the env variable
    # or else environment variable DATABASE_URL will be used
    db_url=""
    if os.environ['DATABASE_URL']:
        db_url = os.environ['DATABASE_URL']

    app.config['SQLALCHEMY_DATABASE_URI'] = db_url
    app.config['SECRET_KEY'] = 'thisisasecret'

    db.init_app(app)
    CORS(app)

    from .auth import auth as auth_blueprint
    app.register_blueprint(auth_blueprint)

    from .main import main as main_blueprint
    app.register_blueprint(main_blueprint)

    return app
