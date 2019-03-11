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
    word2 = SentimentWord("bad")
    word3 = SentimentWord("hate")
    word4 = SentimentWord("person")
    word5 = SentimentWord("people")
    word6 = SentimentWord("food")
    word7 = SentimentWord("actor")
    word8 = SentimentWord("meal")
    word9 = SentimentWord("happy")
    word10 = SentimentWord("good")

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
        if word6.word in sentence:
            return word6
        elif word7.word in sentence:
            return word7
        elif word8.word in sentence:
            return word8
        elif word9.word in sentence:
            return word9
        elif word10.word in sentence:
            return word10

    db.session.add(word1)
    db.session.add(word2)
    db.session.add(word3)
    db.session.add(word4)
    db.session.add(word5)
    db.session.add(word6)
    db.session.add(word7)
    db.session.add(word8)
    db.session.add(word9)
    db.session.add(word10)
    db.session.commit()

    positive, negative = random_data.load_files()

    for month in range(1, 13):
        for day in range(1, 29):
            text = ""
            all_data = []
            for para in range(5):
                paragraph = ""

                for sent in range(10):
                    chance = 0.25

                    if month == 1:
                        chance = 0.95

                    if month in [2, 6, 7, 11, 12]:
                        chance = 0.65

                    if random.uniform(0, 1) < chance:
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
