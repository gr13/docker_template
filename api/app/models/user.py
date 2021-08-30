import logging
from app.db import db
from app.models.user_right import UserRightModel
from sqlalchemy.orm import validates
from werkzeug.security import generate_password_hash, check_password_hash

import secrets


class UserModel(db.Model):
    __tablename__ = 'users'

    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(255))
    password = db.Column(db.String(110))
    right_id = db.Column(
        db.Integer,
        db.ForeignKey('rights.id'),
        default=1
    )
    right = db.relationship('UserRightModel', back_populates="users")

    username = db.Column(db.String(100), default='')
    position = db.Column(db.String(100), default='')

    can_edit = db.Column(db.Boolean(), default=0)
    can_seelog = db.Column(db.Boolean(), default=0)
    can_seeusers = db.Column(db.Boolean(), default=0)

    hide = db.Column(db.Boolean(), default=0)

    @validates('email')
    def validate_email(self, key, email):
        assert '@' in email
        return email

    def __init__(self, email, username, _password):
        self.email = email
        self.username = username
        self.password = self.set_password(_password)

    def json(self):
        right = UserRightModel.find_by_id(self.right_id)
        return {'id': self.id,
                'email': self.email,
                'right_id': self.right_id,
                'right': self.right.json(),
                'username': self.username,
                'position': self.position,
                'can_edit': self.can_edit,
                'can_seelog': self.can_seelog,
                'can_seeusers': self.can_seeusers,
                'hide': self.hide
                }

    @classmethod
    def find_by_email(cls, email):
        return cls.query.filter_by(email=email).first()

    @classmethod
    def find_by_id(cls, _id):
        return cls.query.filter_by(id=_id).first()

    @classmethod
    def find_all(cls):
        return cls.query.all()

    def save_to_db(self):
        db.session.add(self)
        db.session.commit()

    def delete_from_db(self):
        db.session.delete(self)
        db.session.commit()

    def set_password(self, _password):
        return generate_password_hash(_password)

    def check_password(self, _password):
        return check_password_hash(self.password, _password)

    @classmethod
    def create_random_password(cls):
        return secrets.tocken_hex(8)
