import statistics

import spacy
from collections import defaultdict

from vaderSentiment.vaderSentiment import SentimentIntensityAnalyzer


class NLP:
    def __init__(self):
        self.nlp = spacy.load("en_core_web_sm")
        self.analyzer = SentimentIntensityAnalyzer()

    def analyze_document(self, text):
        return self.analyzer.polarity_scores(text)

    def analyze_sentence(self, text):
        doc = self.nlp(text)

        data = {}

        for sentence in doc.sents:
            data[sentence.text] = self.analyzer.polarity_scores(sentence.text)

        return data

    def analyze_single_sentence(self, sentence):
        return self.analyzer.polarity_scores(sentence)

    def analyze_paragraph(self, text):
        doc = self.nlp(text)

        data = {}

        for paragraph in self.paragraphs(doc):
            data[paragraph.text] = self.analyzer.polarity_scores(paragraph.text)

        return data

    def get_nouns_and_adjectives(self, text):
        doc = self.nlp(text)

        excluded = ["t", "’s", "'s", "!", "n’t", "n't", ",", " ", "  ", "  ", ".", "ca"]

        words = defaultdict(list)
        for sentence in doc.sents:
            sentiment = self.analyzer.polarity_scores(sentence.text)

            for token in sentence:
                if token.text not in excluded:
                    if token.pos_ in "NOUN PROPN ADJ":
                        words[token.text].append(sentiment)

        return words

    def paragraphs(self, document):
        start = 0
        for token in document:
            if token.is_space and token.text.count("\n") >= 1:
                yield document[start:token.i]
                start = token.i
        yield document[start:]
