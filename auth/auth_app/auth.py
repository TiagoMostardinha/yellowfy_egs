import secrets
from flask import Blueprint, abort, jsonify, render_template, redirect, session, url_for, request, flash
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import login_user, logout_user, login_required
from models import User
from app import db
from flask_jwt_extended import create_access_token, create_refresh_token, jwt_required, get_jwt_identity, get_jwt
from authlib.integrations.flask_client import OAuth
from flask import current_app as app

auth = Blueprint('auth', __name__)
oauth = OAuth(app)

google = oauth.register(
    'google',
    client_id='422415598710-9qgcl2923q32a0ug4mie79mb6jar0g5l.apps.googleusercontent.com',
    client_secret='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',
    authorize_url='https://accounts.google.com/o/oauth2/auth',
    access_token_url='https://accounts.google.com/o/oauth2/token',
    client_kwargs={'scope': 'openid profile email'},
    jwks_uri="https://www.googleapis.com/oauth2/v3/certs",
    redirect_uri='http://grupo6-egs-deti.ua.pt/auth/login/google/callback'
)

@auth.route('/auth/login')
def login():
    return render_template('login.html')

@auth.route('/auth/login', methods=['POST'])
def login_post():
    email = request.form.get('email')
    password = request.form.get('password')
    remember = True if request.form.get('remember') else False

    user = User.query.filter_by(email=email).first()

    if not user or not check_password_hash(user.password, password): 
        flash('Please check your login details and try again.')
        return redirect(url_for('auth.login'))

    login_user(user, remember=remember)
    user_id = user.id
    access_token = create_access_token(identity=user.id)
    refresh_token = create_refresh_token(identity=user.id)

    return {'access_token': access_token, 'refresh_token': refresh_token}, 200

@auth.route('/auth/signup')
def signup():
    return render_template('signup.html')

@auth.route('/auth/signup', methods=['POST'])
def signup_post():

    email = request.form.get('email')
    name = request.form.get('name')
    password = request.form.get('password')
    looking_for_work = request.form.get('looking_for_work') == 'on'
    mobile_number = request.form.get('mobile_number')

    user = User.query.filter_by(email=email).first()

    if user:
        flash('Email address already exists')
        return redirect(url_for('auth.signup'))

    new_user = User(email=email, name=name, password=generate_password_hash(password, method='pbkdf2:sha256'), looking_for_work=looking_for_work, mobile_number=mobile_number)

    db.session.add(new_user)
    db.session.commit()

    return redirect(url_for('auth.login'))

@auth.route('/auth/userinfo')
@jwt_required()
def userinfo():
    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    if user:
        return {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'looking_for_work': user.looking_for_work,
            'mobile_number': user.mobile_number,
        }, 200
    else:
        return 'User not found', 404

@auth.route('/auth/refresh', methods=['POST'])
@jwt_required(refresh=True)
def refresh():
    current_user_id = get_jwt_identity()
    access_token = create_access_token(identity=current_user_id)
    return {'access_token': access_token}, 200

@auth.route('/auth/login/google')
def google_login():
    state = secrets.token_urlsafe(16)
    nonce = secrets.token_urlsafe(16)
    session['oauth_state'] = state
    session['oauth_nonce'] = nonce
    redirect_uri = 'http://grupo6-egs-deti.ua.pt/auth/login/google/callback'
    return google.authorize_redirect(redirect_uri=redirect_uri, state=state, nonce=nonce)



@auth.route('/auth/login/google/callback')
def google_callback():

    if request.args.get('state') != session.get('oauth_state'):
        abort(403, 'Invalid state')

    token = google.authorize_access_token()
    # create nonce
    nonce = session.pop('oauth_nonce', None)
    user_info = google.parse_id_token(token, nonce)

    user_info = google.get("https://www.googleapis.com/oauth2/v2/userinfo", verify=False).json()

    if 'email' not in user_info:
        abort(500, 'Email not found in user info')

    user = User.query.filter_by(email=user_info['email']).first()

    google_token = token['access_token']  # Fetching Google token

    if not user:
        return render_template('additional_info.html', email=user_info['email'],name=user_info['name'], google_token=google_token)
    else:
        user.email = user_info['email']
        user.name = user_info['name']
        user.google_token = google_token  # Updating google_token

        user_id = user.id
        access_token = create_access_token(identity=user.id)
        refresh_token = create_refresh_token(identity=user.id)

        db.session.commit()

        login_user(user)

        return {'access_token': access_token, 'refresh_token': refresh_token}, 200


@auth.route('/auth/additional_info', methods=['POST'])
def additional_info():

    email = request.form.get('email')
    name = request.form.get('name')
    looking_for_work = request.form.get('looking_for_work') == 'on'
    mobile_number = request.form.get('mobile_number')
    google_token = request.form.get('google_token')

    user = User.query.filter_by(email=email).first()

    if not user:
        user = User(email=email, 
                    name=name, 
                    password=generate_password_hash(secrets.token_urlsafe(16), method='pbkdf2:sha256'), 
                    looking_for_work=looking_for_work, 
                    mobile_number=mobile_number, 
                    google_token=google_token)
        db.session.add(user)
    else:
        user.name = name
        user.looking_for_work = looking_for_work
        user.mobile_number = mobile_number
        user.google_token = google_token

    db.session.commit()

    user_id = user.id
    access_token = create_access_token(identity=user.id)
    refresh_token = create_refresh_token(identity=user.id)

    login_user(user)

    return {'access_token': access_token, 'refresh_token': refresh_token}, 200


@auth.route('/auth/get_google_token', methods=['POST'])
@jwt_required()
def get_google_token():

    current_user_id = get_jwt_identity()
    user = User.query.get(current_user_id)
    if user:
        return {
            'google_token': user.google_token
        }, 200
    else:
        return 'User not found', 404

@auth.route('/auth/all_users_google_token', methods=['GET'])
@jwt_required()
# return id and google_token of all users
def all_users_google_token():
    
        users = User.query.all()
        users_google_token = []
        # Fetching google_token of all users and id
        for user in users:
            users_google_token.append({'id': user.id, 'google_token': user.google_token})
    
        return jsonify(users_google_token)

@auth.route('/auth/logout')
@jwt_required()
def logout():
    logout_user()
    return redirect(url_for('main.index'))
