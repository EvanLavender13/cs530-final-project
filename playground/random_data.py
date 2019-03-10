import random


def load_files():
    positive = []
    negative = []

    with open("playground/data/amazon_cells_labelled.txt") as file:
        lines = file.readlines()

        for line in lines:
            line = line.strip()
            # print(line)

            sentiment = int(line[-1:])
            # print(sentiment)

            sentence = line[:-1].strip()
            # print(sentence)

            positive.append(sentence) if sentiment == 1 else negative.append(sentence)

    print("positive sentences:", len(positive))

    with open("playground/data/imdb_labelled.txt") as file:
        lines = file.readlines()

        for line in lines:
            line = line.strip()
            # print(line)

            sentiment = int(line[-1:])
            # print(sentiment)

            sentence = line[:-1].strip()
            # print(sentence)

            positive.append(sentence) if sentiment == 1 else negative.append(sentence)

    with open("playground/data/yelp_labelled.txt") as file:
        lines = file.readlines()

        for line in lines:
            line = line.strip()
            # print(line)

            sentiment = int(line[-1:])
            # print(sentiment)

            sentence = line[:-1].strip()
            # print(sentence)

            positive.append(sentence) if sentiment == 1 else negative.append(sentence)

    random.shuffle(positive)
    random.shuffle(negative)

    return positive, negative



