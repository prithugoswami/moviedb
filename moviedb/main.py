from flask import (Flask, render_template, request, url_for, Blueprint, g,
        Response)
from . import db, session, g
from .models import user_info, fav
from imdb import IMDb
from pprint import pprint as pp
import tmdbsimple as tmdb
import json



tmdb.API_KEY = 'b888b64c9155c26ade5659ea4dd60e64'

main = Blueprint('main', __name__)


# local - use local mysql db
local=False

# enable_extra - loads poster and plot overview from tmdb for movie info
enable_extra=True

# to laod posters on profile page
posters_on_profile_page=False

tmdb_img_url = r'https://image.tmdb.org/t/p/w342'


if local:
    ia = IMDb('s3', 'mysql+mysqldb://may:venom123@localhost/imdb')
else:
    ia = IMDb()

def db_fav_exists(tconst, user_id):
    """
    checks if the tconst exists as a favorite for the user of user id `user_id`
    """
    fav_tconst = fav.query.filter_by(user_id=user_id).all()
    if fav_tconst: # user already has favorites
        for a in fav_tconst:
            if a.tconst == int(tconst): # the same tconst already exists
                return True

    return False

def db_get_userid(username):
    """
    get the user id of the username from the user_info table
    """
    user = user_info.query.filter_by(username=username).first()
    if user:
        return user.user_id
    else:
        return -1


@main.route('/')
def index():
    # I know this is a very hacky way of doing this; I am already cringing
    return render_template("index.html").replace('<html lang="en"',
            '<html lang="en" style="background-image:url(../static/img/bg.jpg)"'
            ,1)

@main.route('/search')
def search():
    query = request.args.get('q', None)
    if query:
        q_res = ia.search_movie(query)
        results = []
        if local:
            for m in q_res:
                try:
                    results.append({
                        'id': m.getID(),
                        'title': m['title'],
                        'year': m['startYear'],
                        'kind': m['kind']
                        })
                except KeyError:
                    pass
        else: #if not local
            results = [{
                'id': m.getID(),
                'cover': m['cover url'],
                'title': m['title'],
                'year':  m.get('year', ''),
                'kind':  m['kind']
                } for m in q_res]

        return render_template("search.html", results=results,
                local=local).replace('<html lang="en"',
                    '<html lang="en" style="background-color:#efefef"',
                    1)
    else: #not query
        return ('')

@main.route('/profile')
def profile():
    if not session.get('user', None):
        return render_template('profile.html')

    user_id = db_get_userid(session['user'])
    fav_query = fav.query.filter_by(user_id=user_id).all()
    fav_tconsts = [a.tconst for a in fav_query]
    user = user_info.query.filter_by(user_id=user_id).first()

    user_data = {}
    user_data['movies'] = []
    user_data['favorite_count'] = len(fav_tconsts)
    user_data['favorite_genre'] = user.fav_genre
    user_data['recent_fav'] = user.recent_fav
    for a in fav_tconsts:
        movie = {}
        mov = ia.get_movie(a)

        long_title = mov.get('long imdb title')
        genres = (", ".join(mov.get('genres', []))).title()
        rating = mov.get('rating', None)
        cover =  None

        if posters_on_profile_page:
            find = tmdb.Find('tt{:07}'.format(int(a)))
            find.info(external_source='imdb_id')
            cover_path =  None

            if find.movie_results:
                cover_path = find.movie_results[0].get('poster_path', None)
            elif find.tv_results:
                cover_path = find.tv_results[0].get('poster_path', None)

            if cover_path:
                cover = tmdb_img_url + cover_path

        movie = {
                'id': a,
                'long title': long_title,
                'rating': rating if rating else '',
                'genres': genres,
                'cover': cover if cover else ''
        }

        user_data['movies'].append(movie)

    return render_template('profile.html',
            user_data=user_data,
            posters_on_profile_page=posters_on_profile_page)

@main.route('/info')
def info():
    movid = request.args.get('id', None)
    if not movid:
        return ('')
    else:
        mov = ia.get_movie(movid)
        movie={}

        #collect all the relevent info in a dict 'movie'
        long_title = mov.get('long imdb title')
        title = mov.get('title')
        rating = mov.get('rating', None)
        genres = (", ".join(mov.get('genres', []))).title()
        runmin = 0
        if mov.get('runtime'):
            runmin = int(mov.get('runtime', ['0'])[0])
        runtime = "{}h {}m".format(runmin//60, runmin%60)

        director = ''
        writer = ''
        if mov.get('director'):
            director = mov.get('director')[0]['name']
        if mov.get('writer'):
            writer = mov.get('writer')[0]['name']

        cover = mov.get('full-size cover url', None)
        plot = mov.get('plot', [''])[0].split('::')[0]

        if enable_extra:
            find = tmdb.Find('tt{:07}'.format(int(movid)))
            find.info(external_source='imdb_id')
            if (find.movie_results and find.movie_results[0]['poster_path']
            and find.movie_results[0]['overview']):
                cover = tmdb_img_url + find.movie_results[0]['poster_path']
                plot = find.movie_results[0]['overview']
            elif (find.tv_results and find.tv_results[0]['poster_path']
            and find.tv_results[0]['overview']):
                cover = tmdb_img_url + find.tv_results[0]['poster_path']
                plot = find.tv_results[0]['overview']

        movie = {
                'id': mov.getID(),
                'long title': long_title,
                'title': title,
                'rating': rating if rating else '',
                'genres': genres,
                'runtime': runtime,
                'director': director,
                'writer': writer,
                'plot': plot if plot else '',
                'cover': cover if cover else ''
        }

        isfavorite = False
        if session.get('user', None):
            isfavorite = db_fav_exists(tconst = movie['id'],
                    user_id = db_get_userid(session['user']))


        return render_template("info.html",
                movie=movie,
                isfavorite=isfavorite).replace(
                '<html lang="en"',
                '<html lang="en" style="background-color:#efefef"',
                1)

@main.route('/fav', methods=['POST'])
def favorite():
    resp = {}
    if not session.get('user', None):
        resp['status'] = 'error'
        resp['message'] = 'not logged in'
        return Response(json.dumps(resp),
                status=401,
                mimetype='application/json')

    remove = request.form.get('remove', None)
    tconst = request.form.get('tconst', None)

    user_id = db_get_userid(session['user'])
    # user = user_info.query.filter_by(username=session['user']).first()
    # user_id = user.user_id

    if db_fav_exists(tconst=tconst, user_id=user_id):
        if remove:
            toremove = fav.query.filter_by(user_id=user_id,
                    tconst=int(tconst)).first()

            db.session.delete(toremove)
            db.session.commit()
            resp['status'] = 'success'
            resp['actiontype'] = 'remove'
            resp['message'] = 'removed the title from favorites'
        else:
            resp['status'] = 'warning'
            resp['actiontype'] = 'none'
            resp['message'] = 'title already in favorites'
        return Response(json.dumps(resp),
                status=200,
                mimetype='application/json')

    db.session.add(fav(tconst=tconst, user_id=user_id))
    db.session.commit()
    resp['status'] = 'success'
    resp['actiontype'] = 'add'
    resp['message'] = 'added to favorites'
    return Response(json.dumps(resp),
            status=200,
            mimetype='application/json')
