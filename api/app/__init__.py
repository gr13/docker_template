import os
# import sys
import logging
from flask import Flask, request, has_request_context
from flask_restful import Api
from flask_jwt_extended import JWTManager
from app.blacklist import BLACKLIST

from app.resources.user import (
    UserRegister,
    User,
    UserLogin,
    UserLogout,
    UserList
)

app = Flask(__name__)
app.config['SECRET_KEY'] = os.environ['FLASK_SECRET_KEY']
app.config['DEBUG'] = os.environ['DEBUG']
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['PROPAGATE_EXEPTIONS'] = True
app.config['JWT_BLACKLIST_ENABLED'] = True
app.config['JWT_BLACKLIST_TOKEN_CHECKS'] = ['access', 'refresh']

# https://flask.palletsprojects.com/en/2.0.x/logging/
log_format = f'[%(asctime)s] %(levelname)s in %(module)s: %(message)s'
logging.basicConfig(filename='/logs/api.log', level=logging.DEBUG, format=log_format)


api = Api(app)

jwt = JWTManager(app)

@app.before_request
def log_request_info():
    app.logger.info("######################################################")
    app.logger.info("Request:")
    if has_request_context():
            url = request.url
            remote_addr = request.remote_addr
            app.logger.info(f"ip: {remote_addr}, url: {url}")
    if request.headers:
        app.logger.info("Headers: %s", request.headers)
    if request.get_data():
        app.logger.info("Body: %s", request.get_data().decode('ascii'))
    if request.get_json():
        app.logger.info("Json: %s", request.get_json())
    app.logger.info("######################################################")

@jwt.token_in_blocklist_loader
def check_if_token_in_blacklist(decrypted_token):
    return decrypted_token['jti'] in BLACKLIST


# @jwt.user_claims_loader
# def add_claims_to_jwt(identity):
#     user = UserModel.find_by_id(identity)
#     rights = {
#         "right_id": 1,
#         "is_admin": 0,
#         "is_blocked": 1
#     }
#     if user:
#         rights = {
#             "right_id": user.right_id,
#             "is_admin": user.right_id == 7,
#             "is_blocked": user.right_id == 1
#         }

#     return rights


# api.add_resource(Country, '/country/<string:title>')
# api.add_resource(CountryList, '/countries')

# api.add_resource(Region, '/region/<int:region_id>')
# api.add_resource(RegionList, '/regions')

# api.add_resource(SkinColor, '/skincolor/<int:skincolor_id>')
# api.add_resource(SkinColorList, "/skincolors")


api.add_resource(UserRegister, '/register')
api.add_resource(User, '/user/<int:user_id>')
api.add_resource(UserLogin, '/login')
api.add_resource(UserLogout, '/logout')
api.add_resource(UserList, '/users')


@app.route("/")
def hello():
    app.logger.debug('Hello World!')
    # app.logger.info('Info Message')
    # app.logger.warning('Warning Message')
    # app.logger.error('Error Message')
    # app.logger.critical('Critical ')
    return "Hello World!"


# sys.stdout = sys.stderr = open('log/flasklog.txt','wt')