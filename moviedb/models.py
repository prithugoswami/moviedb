from . import db

class user_info(db.Model):
    user_id = db.Column(db.Integer, primary_key=True)
    password = db.Column(db.String(100))
    username = db.Column(db.String(100), unique=True)
    fav_genre = db.Column(db.String(100))
    recent_fav = db.Column(db.String)

class fav(db.Model):
    user_id = db.Column(db.Integer, primary_key=True)
    tconst = db.Column(db.Integer, primary_key=True)
