from flask import (Blueprint, render_template, redirect,
        url_for, request, flash)
from werkzeug.security import generate_password_hash, check_password_hash
from .models import user_info, fav
from . import db, session, g

auth = Blueprint('auth', __name__)

@auth.route('/login')
def login():
    newuser = request.args.get('nu', None)
    return render_template("login.html", newuser=newuser).replace(
            '<html lang="en"',
            '<html lang="en" style="background-image:url(../static/img/bg.jpg)"'
            ,1)

@auth.route('/login', methods=['POST'])
def login_post():
    username = request.form.get('username')
    password = request.form.get('password')
    remember = True if request.form.get('remember') else False

    user = user_info.query.filter_by(username=username).first()

    if not user or not check_password_hash(user.password, password): 
        flash('Please check your login details and try again.')
        return redirect(url_for('auth.login'))
    else:
        session['user'] = username
        g.user = session['user']
        return redirect(url_for('main.profile'))

@auth.route('/signup')
def signup():
    return render_template("signup.html").replace('<html lang="en"',
            '<html lang="en" style="background-image:url(../static/img/bg.jpg)"'
            ,1)

@auth.route('/signup', methods=['POST'])
def signup_post():
    username = request.form.get('username')
    password = request.form.get('password')

    if not username or not password:
        flash("Username or Password cannot be emtpy")
        return redirect(url_for('auth.signup'))

    user = user_info.query.filter_by(username=username).first()

    if user:
        flash('Username already exists')
        return redirect(url_for('auth.signup'))

    new_user = user_info(username=username, password=generate_password_hash(
        password, method='sha256'))

    db.session.add(new_user)
    db.session.commit()

    return redirect(url_for('auth.login', nu=1))

@auth.route('/logout')
def logout():
    session['user'] = None
    return redirect(url_for('auth.login'))
