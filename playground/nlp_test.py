import spacy
from collections import defaultdict

nlp = spacy.load("en_core_web_sm")

#doc = nlp("My feet are small and they stink!")
#doc = nlp("Feet are the worst thing ever!")
doc = nlp("Monday is the worst day. The worst day is Monday. I hate Monday! Monday is no good. "
          "Whenever I think about Monday I feel sick.")

nouns = defaultdict(set)
for sentence in doc.sents:
    print(sentence)
    for token in sentence:
        if token.dep == spacy.symbols.nsubj or token.dep == spacy.symbols.attr:
            for t in token.lefts:
                nouns[token.text].add(t.text)

            for t in token.rights:
                nouns[token.text].add(t.text)

        if token.dep_ == "ROOT":
            print([child for child in token.children])


        print(token.orth_, token.dep_, token.head.orth_, [t.orth_ for t in token.lefts],
              [t.orth_ for t in token.rights])

    print()

print(nouns)


