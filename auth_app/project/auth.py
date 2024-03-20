# auth.py

from flask import Blueprint, render_template, redirect, url_for, request, flash
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user, logout_user, login_required
from .models import User
from . import db
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt_identity
from authlib.integrations.flask_client import OAuth
from flask import current_app as app

auth = Blueprint('auth', __name__)
oauth = OAuth(app)

google = oauth.register(
        name='google',
        client_id='your_google_client_id',
        client_secret='your_google_client_secret',
        authorize_url='https://accounts.google.com/o/oauth2/auth',
        authorize_params=None,
        access_token_url='https://accounts.google.com/o/oauth2/token',
        access_token_params=None,
        refresh_token_url=None,
        refresh_token_params=None,
        redirect_uri='http://localhost:5000/login/google/callback',
        client_kwargs={'scope': 'openid profile email'}
)

@auth.route('/login')
def login():
    return render_template('login.html')

@auth.route('/login', methods=['POST'])
def login_post():
    email = request.form.get('email')
    password = request.form.get('password')
    remember = True if request.form.get('remember') else False

    user = User.query.filter_by(email=email).first()

    # check if user actually exists
    # take the user supplied password, hash it, and compare it to the hashed password in database
    if not user or not check_password_hash(user.password, password): 
        flash('Please check your login details and try again.')
        return redirect(url_for('auth.login')) # if user doesn't exist or password is wrong, reload the page

    # if the above check passes, then we know the user has the right credentials
    login_user(user, remember=remember)
    #obtain user_id from user object
    user_id = user.id
    access_token = create_access_token(identity=user.id)
    refresh_token = create_refresh_token(identity=user.id)

    return {'access_token': access_token, 'refresh_token': refresh_token}, 200

@auth.route('/signup')
def signup():
    return render_template('signup.html')

@auth.route('/signup', methods=['POST'])
def signup_post():

    email = request.form.get('email')
    name = request.form.get('name')
    password = request.form.get('password')
    looking_for_work = request.form.get('looking_for_work') == 'on'  # Assuming the input name is 'looking_for_work'
    print(looking_for_work)
    mobile_number = request.form.get('mobile_number')

    user = User.query.filter_by(email=email).first() # if this returns a user, then the email already exists in database

    if user: # if a user is found, we want to redirect back to signup page so user can try again  
        flash('Email address already exists')
        return redirect(url_for('auth.signup'))

    # create new user with the form data. Hash the password so plaintext version isn't saved.
    new_user = User(email=email, name=name, password=generate_password_hash(password, method='pbkdf2:sha256'), looking_for_work=looking_for_work, mobile_number=mobile_number)

    # add the new user to the database
    db.session.add(new_user)
    db.session.commit()

    return redirect(url_for('auth.login'))

@auth.route('/userinfo')
@jwt_required()  # Secure the endpoint with JWT authentication
def userinfo():
    current_user_id = get_jwt_identity()
    # Retrieve user information based on user_id
    user = User.query.get(current_user_id)
    if user:
        # Return user information including the new fields
        return {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'looking_for_work': user.looking_for_work,
            'mobile_number': user.mobile_number
        }, 200
    else:
        return 'User not found', 404

@auth.route('/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    current_user_id = get_jwt_identity()  # Get the user ID from the refresh token
    access_token = create_access_token(identity=current_user_id)  # Generate a new access token
    return { 'access_token': access_token}, 200

@auth.route('/login/google')
def google_login():
    return google.authorize_redirect(redirect_uri=url_for('auth.google_login', _external=True))

@auth.route('/logout')
@jwt_required
def logout():
    logout_user()
    return redirect(url_for('main.index'))

