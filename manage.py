import random

from flask_migrate import Migrate, MigrateCommand
from flask_script import Manager

from app import app, db, nlp
from models import User, Entry, SentimentData, SentimentWord
from playground import random_data

migrate = Migrate(app, db)
manager = Manager(app)

# migrations
manager.add_command('db', MigrateCommand)


@manager.command
def create_db():
    """Creates the db tables."""
    db.create_all()


@manager.command
def drop_db():
    """Drops the db tables."""
    db.drop_all()


@manager.command
def create_admin():
    """Creates the admin user."""
    db.session.add(User(email='ad@min.com', password='admin', admin=True))
    db.session.commit()


@manager.command
def create_data():
    drop_db()
    create_db()

    """Creates sample data."""
    user = User(email="test@test.com", password="test")

    db.session.add(user)
    db.session.commit()

    user = User.query.get(1)

    word1 = SentimentWord("movie")
    word2 = SentimentWord("movies")
    word3 = SentimentWord("television")
    word4 = SentimentWord("person")
    word5 = SentimentWord("people")

    def is_word_in_sentence(sentence):
        if word1.word in sentence:
            return word1
        elif word2.word in sentence:
            return word2
        elif word3.word in sentence:
            return word3
        elif word4.word in sentence:
            return word4
        elif word5.word in sentence:
            return word5

    db.session.add(word1)
    db.session.add(word2)
    db.session.add(word3)
    db.session.add(word4)
    db.session.add(word5)
    db.session.commit()

    positive, negative = random_data.load_files()

    for month in range(1, 13):
        for day in range(1, 29):
            text = ""
            all_data = []
            for para in range(5):
                paragraph = ""

                for sent in range(10):
                    if random.uniform(0, 1) < 0.5:
                        sentence = random.choice(negative)
                    else:
                        sentence = random.choice(positive)

                    word = is_word_in_sentence(sentence)
                    if word:
                        word_sent = nlp.analyze_single_sentence(sentence)
                        word_data = SentimentData(sentiment=word_sent, word=word.word)
                        all_data.append(word_data)

                    paragraph += sentence + " "

                paragraph += "\n\n"

                text += paragraph

            sentiment = nlp.analyze_document(text)
            sentiment_data = SentimentData(sentiment=sentiment,
                                           is_total=True)
            all_data.append(sentiment_data)
            entry = Entry(user_id=user.get_id(), year=2019, month=month, day=day, content=text, sentiment_data=all_data)

            db.session.add(entry)

    db.session.commit()


if __name__ == '__main__':
    manager.run()
