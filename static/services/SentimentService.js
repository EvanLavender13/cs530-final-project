function SentimentService() {
    var self = riot.observable(this)

    qwest.setDefaultDataType("json");

    self.getDocument = function (text) {
        qwest.post("api/sent_document", {"doc": text})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("document", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.getParagraph = function (text) {
        qwest.post("api/sent_paragraph", {"doc": text})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("paragraph", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.getSentence = function (text) {
        qwest.post("api/sent_sentence", {"doc": text})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("sentence", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.getNounsAndAdjectives = function (text) {
        qwest.post("api/sent_noun_adj", {"doc": text})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("noun", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.getColorFromSentiment = function (sentiment) {
        var r = 0
        var g = 0
        var b = 0

        /*
        #. positive sentiment: compound score >= 0.05
        #. neutral sentiment: (compound score > -0.05) and (compound score < 0.05)
        #. negative sentiment: compound score <= -0.05
         */
        var comp = sentiment["compound"]

        if (comp >= 0.05) {
            // positive
            g = 255 * (comp)
        } else if (comp > -0.05 && comp < 0.05) {
            // neutral
            b = 255 * sentiment["neu"]

            if (comp < 0) {
                r = 255 * comp
            } else {
                g = 255 * Math.abs(comp)
            }
        } else if (comp <= -0.05) {
            // negative
            r = 255 * (Math.abs(comp))
        }

        r = self.norm(r, 0, 255)
        g = self.norm(g, 0, 255)
        b = self.norm(b, 0, 255)

        return "rgba(" + r + "," + g + "," + b + ", 0.5)"
    }

    self.norm = function (value, min, max) {
        return Math.min(Math.max(value, min), max);
    }

    self.getTooltip = function (sentiment) {
        var tooltip = ""

        var comp = sentiment["compound"]
        if (comp >= 0.05) {
            // positive
            tooltip += "Positive"
        } else if (comp > -0.05 && comp < 0.05) {
            // neutral
            tooltip += "Neutral"


        } else if (comp <= -0.05) {
            // negative
            tooltip += "Negative"
        }

        return tooltip
    }
}