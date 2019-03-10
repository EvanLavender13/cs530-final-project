import datetime

from app import db, bcrypt


class User(db.Model):
    __tablename__ = "users"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(255), unique=True, nullable=False)
    password = db.Column(db.String(255), nullable=False)
    registered_on = db.Column(db.DateTime, nullable=False)
    admin = db.Column(db.Boolean, nullable=False, default=False)

    # entries = db.relationship("Entry", backref="user", lazy="dynamic")

    def __init__(self, email, password, admin=False):
        self.email = email
        self.password = bcrypt.generate_password_hash(password)
        self.registered_on = datetime.datetime.now()
        self.admin = admin

    def get_id(self):
        return self.id

    def __repr__(self):
        return "<User {0}>".format(self.email)


class Entry(db.Model):
    __tablename__ = "entries"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey("users.id"))
    year = db.Column(db.Integer, nullable=False, index=True)
    month = db.Column(db.Integer, nullable=False, index=True)
    day = db.Column(db.Integer, nullable=False, index=True)
    content = db.Column(db.String, nullable=False)

    sentiment_data = db.relationship("SentimentData", backref="sentiment", lazy="dynamic",
                                     primaryjoin="and_(Entry.id==SentimentData.entry_id, "
                                                 "Entry.user_id==SentimentData.user_id)")

    def __init__(self, user_id, year, month, day, content, sentiment_data):
        self.user_id = user_id
        self.year = year
        self.month = month
        self.day = day
        self.content = content
        self.sentiment_data = sentiment_data

    def get_id(self):
        return self.id


class SentimentData(db.Model):
    __tablename__ = "sentiment_data"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    user_id = db.Column(db.Integer, db.ForeignKey("entries.user_id"), index=True)
    entry_id = db.Column(db.Integer, db.ForeignKey("entries.id"), index=True)
    word = db.Column(db.String, nullable=True)
    is_total = db.Column(db.Boolean, nullable=False)
    compound = db.Column(db.Float, nullable=False)
    positive = db.Column(db.Float, nullable=False)
    neutral = db.Column(db.Float, nullable=False)
    negative = db.Column(db.Float, nullable=False)

    def __init__(self, sentiment, word=None, is_total=False):
        self.word = word
        self.is_total = is_total
        self.compound = sentiment["compound"]
        self.positive = sentiment["pos"]
        self.neutral = sentiment["neu"]
        self.negative = sentiment["neg"]


class SentimentWord(db.Model):
    __tablename__ = "sentiment_words"

    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    word = db.Column(db.String, nullable=False)

    def __init__(self, word):
        self.word = word
