import statistics
from collections import defaultdict

from flask import Flask, render_template, session, request, jsonify
from flask_bcrypt import Bcrypt
from flask_sqlalchemy import SQLAlchemy

from config import BaseConfig
from nlp import NLP

app = Flask(__name__)
app.config.from_object(BaseConfig())

bcrypt = Bcrypt(app)
db = SQLAlchemy(app)
nlp = NLP()

from models import User, Entry


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/api/register", methods=["POST"])
def register():
    json_data = request.get_json()
    user = User(
        email=json_data["email"],
        password=json_data["password"]
    )

    try:
        db.session.add(user)
        db.session.commit()
        session["logged_in"] = True
        session["user_id"] = user.get_id()
        status = "success"
    except:
        status = "this user is already registered"

    db.session.close()
    return jsonify({"result": status})


@app.route("/api/login", methods=["POST"])
def login():
    json_data = request.get_json()
    user = User.query.filter_by(email=json_data["email"]).first()

    if user and bcrypt.check_password_hash(
            user.password, json_data["password"]):
        session["logged_in"] = True
        session["user_id"] = user.get_id()
        status = True
    else:
        status = False

    return jsonify({"result": status})


@app.route("/api/logout")
def logout():
    session.pop("logged_in", None)
    session.pop("user_id", None)
    return jsonify({"result": "success"})


@app.route("/api/status")
def status():
    if session.get("logged_in"):
        if session["logged_in"]:
            return jsonify({"status": True})
    else:
        return jsonify({"status": False})


@app.route("/api/year", methods=["GET"])
def entry_year():
    if session["logged_in"]:
        years = []
        for entry in Entry.query.filter_by(user_id=session["user_id"]).with_entities(Entry.year).distinct():
            years.append({"year": entry.year})

        return jsonify({"result": True, "data": years})


@app.route("/api/month", methods=["POST"])
def entry_month():
    if session["logged_in"]:
        json_data = request.get_json()
        months = []
        for entry in Entry.query.filter_by(user_id=session["user_id"], year=json_data["year"]).with_entities(
                Entry.month).distinct():
            months.append({"month": entry.month})

        return jsonify({"result": True, "data": months})


@app.route("/api/day", methods=["POST"])
def entry_day():
    if session["logged_in"]:
        json_data = request.get_json()

        if json_data.get("day"):
            entry = Entry.query.filter_by(user_id=session["user_id"], year=json_data["year"], month=json_data["month"],
                                          day=json_data["day"]).all().pop()

            response = jsonify({"result": True, "data": entry.content})
        else:
            days = []
            for entry in Entry.query.filter_by(year=json_data["year"], month=json_data["month"]):
                days.append({"day": entry.day})

            response = jsonify({"result": True, "data": days})

        return response


@app.route("/api/add", methods=["POST"])
def entry_add():
    if session["logged_in"]:
        json_data = request.get_json()

        entry = Entry(user_id=session["user_id"], year=json_data["year"], month=json_data["month"],
                      day=json_data["day"], content=json_data["content"])

        try:
            db.session.add(entry)
            db.session.commit()
            status = "success"
        except:
            status = "you have already written today"

        return jsonify({"result": status})


@app.route("/api/sent_document", methods=["POST"])
def sentiment_document():
    if session["logged_in"]:
        json_data = request.get_json()
        document = json_data["doc"]

        sentiment_data = nlp.analyze_document(document)

        return jsonify({"result": True, "data": sentiment_data})


@app.route("/api/sent_paragraph", methods=["POST"])
def sentiment_paragraph():
    if session["logged_in"]:
        json_data = request.get_json()
        document = json_data["doc"]

        sentiment_data = nlp.analyze_paragraph(document)

        return jsonify({"result": True, "data": sentiment_data})


@app.route("/api/sent_sentence", methods=["POST"])
def sentiment_sentence():
    if session["logged_in"]:
        json_data = request.get_json()
        document = json_data["doc"]

        sentiment_data = nlp.analyze_sentence(document)

        return jsonify({"result": True, "data": sentiment_data})


@app.route("/api/sent_noun_adj", methods=["POST"])
def sentiment_nouns_and_adjectives():
    if session["logged_in"]:
        json_data = request.get_json()
        document = json_data["doc"]

        sentiment_data = nlp.get_nouns_and_adjectives(document)

        return jsonify({"result": True, "data": sentiment_data})


@app.route("/api/summary", methods=["GET"])
def summary():
    if session["logged_in"]:

        summary_data = []
        for entry in Entry.query.filter_by(user_id=session["user_id"]).all():
            sentiment = entry.sentiment_data.filter_by(is_total=True).all().pop()

            summary_data.append({"year": entry.year,
                                 "month": entry.month,
                                 "day": entry.day,
                                 "sentiment": {
                                     "compound": sentiment.compound,
                                     "pos": sentiment.positive,
                                     "neu": sentiment.neutral,
                                     "neg": sentiment.negative
                                 }})

        return jsonify({"result": True, "data": summary_data})


@app.route("/api/data", methods=["POST"])
def data():
    if session["logged_in"]:
        json_data = request.get_json()
        year = json_data["year"]

        return_data = {}
        for month in range(1, 13):
            sentiment_data = defaultdict(list)
            for entry in Entry.query.filter_by(user_id=session["user_id"], year=year, month=month).all():
                for sentiment in entry.sentiment_data.filter_by(is_total=True).all():
                    sentiment_data["compound"].append(sentiment.compound)
                    sentiment_data["positive"].append(sentiment.positive)
                    sentiment_data["neutral"].append(sentiment.neutral)
                    sentiment_data["negative"].append(sentiment.negative)

            if len(sentiment_data) > 0:
                return_data[month] = {
                    "compound": statistics.mean(sentiment_data["compound"]),
                    "positive": statistics.mean(sentiment_data["positive"]),
                    "neutral": statistics.mean(sentiment_data["neutral"]),
                    "negative": statistics.mean(sentiment_data["negative"])
                }

        return jsonify({"result": True, "data": return_data})


@app.route("/api/data_word", methods=["POST"])
def data_word():
    if session["logged_in"]:
        json_data = request.get_json()
        year = json_data["year"]

        return_data = {}
        for month in range(1, 13):
            sentiment_data = {}
            for entry in Entry.query.filter_by(user_id=session["user_id"], year=year, month=month).all():
                for sentiment in entry.sentiment_data.filter_by(is_total=False).all():
                    temp = sentiment_data.get(sentiment.word)
                    if not temp:
                        temp = {
                            "compound": [],
                            "positive": [],
                            "neutral": [],
                            "negative": []
                        }

                    temp["compound"].append(sentiment.compound)
                    temp["positive"].append(sentiment.positive)
                    temp["neutral"].append(sentiment.neutral)
                    temp["negative"].append(sentiment.negative)
                    sentiment_data[sentiment.word] = temp

            if len(sentiment_data) > 0:
                avg_data = {}
                for key, value in sentiment_data.items():
                    avg_data[key] = {
                        "compound": statistics.mean(value["compound"]),
                        "positive": statistics.mean(value["positive"]),
                        "neutral": statistics.mean(value["neutral"]),
                        "negative": statistics.mean(value["negative"]),
                    }

                return_data[month] = avg_data

        return jsonify({"result": True, "data": return_data})


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=8080, debug=True)
