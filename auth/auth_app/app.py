from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager
from flask_jwt_extended import JWTManager
import os
import time
from sqlalchemy.exc import OperationalError

# init SQLAlchemy so we can use it later in our models
db = SQLAlchemy()

def create_app():
    app = Flask(__name__, template_folder='templates')

    app.config['SECRET_KEY'] = 'secret-key-goes-here'

    # MySQL URI
    print(os.environ.get('DATABASE_URI'))
    app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URI')

    #'mysql+pymysql://yellowfy:yellowfy@localhost/flask_app_db'

    jwt = JWTManager(app)
    app.secret_key = 'your_secret_key'

    db.init_app(app)

    login_manager = LoginManager()
    login_manager.login_view = 'auth.login'
    login_manager.init_app(app)

    from models import User

    @login_manager.user_loader
    def load_user(user_id):
        # since the user_id is just the primary key of our user table, use it in the query for the user
        return User.query.get(int(user_id))

    with app.app_context():
        # Retry connecting to the database
        max_retries = 10
        retries = 0
        connected = False
        while retries < max_retries and not connected:
            try:
                db.drop_all()
                connected = True
            except OperationalError as e:
                retries += 1
                print(f"Failed to connect to database. Retrying in 5 seconds. Retry {retries}/{max_retries}")
                time.sleep(5)
        
        if not connected:
            print("Failed to connect to database after maximum retries.")
            return None  # Return None to indicate failure

        # blueprint for auth routes in our app
        from auth import auth as auth_blueprint
        app.register_blueprint(auth_blueprint)

        # blueprint for non-auth parts of app
        from main import main as main_blueprint
        app.register_blueprint(main_blueprint)

        import models

        db.create_all()

    return app
