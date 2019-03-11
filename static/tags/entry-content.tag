<entry-content>

    <div class="content">
        <virtual if={ content }>

            <div class="buttons is-centered">
                <span class="button is-text" onclick={clear}>Clear</span>
                <span class="button is-text" onclick={getDocument}>Document</span>
                <span class="button is-text" onclick={getParagraph}>Paragraph</span>
                <span class="button is-text" onclick={getSentence}>Sentence</span>
                <span class="button is-text" onclick={getNounsAndAdjectives}>Words</span>
            </div>

            <p id="context" class="context">{ content }</p>

        </virtual>
    </div>

    <script>
        var self = this
        self.content = null

        var localRoute = route.create()

        var instance = new Mark(".context");

        localRoute(function () {
            self.content = null
            self.update()
        })

        localRoute("/dash/entries/*/*/*", function () {
            self.update()
        })

        entryService.on("showDay", function (year, month, day, data) {
            self.content = data.content

            self.update()

            sentimentService.getDocument(self.content)
        })

        sentimentService.on("document", function (sentiment) {
            instance.unmark()

            instance.mark(self.content, {
                "className": "doc",
                "separateWordSearch": false
            })

            self.changeColorByClass("doc", sentiment)
        })

        sentimentService.on("paragraph", function (data) {
            instance.unmark()

            var count = 0

            Object.keys(data).forEach(function (paragraph) {
                var className = "paragraph" + count

                instance.mark(paragraph, {
                    "className": className,
                    "separateWordSearch": false
                })

                var sentiment = data[paragraph]

                self.changeColorByClass(className, sentiment)

                count++
            })
        })

        sentimentService.on("sentence", function (data) {
            instance.unmark()

            var count = 0

            Object.keys(data).forEach(function (sentence) {
                var className = "sentence" + count

                instance.mark(sentence, {
                    "className": className,
                    "separateWordSearch": false
                })

                var sentiment = data[sentence]

                self.changeColorByClass(className, sentiment)

                count++
            })
        })

        sentimentService.on("noun", function (data) {
            instance.unmark()

            var count = 0

            Object.keys(data).forEach(function (word) {
                var sentiments = data[word]

                var className = "word" + count

                instance.mark(word, {
                    "className": className,
                    "separateWordSearch": false,
                    "caseSensitive": true,
                    "accuracy": "complementary",
                    "done": function (num) {
                        var marks = document.getElementsByClassName(className)

                        Object.keys(marks).forEach(function (index) {
                            var mark = marks[index]

                            var sentiment = null
                            while (!sentiment) {
                                sentiment = sentiments[index--]
                            }

                            var color = self.getColorFromSentiment(sentiment)

                            mark.style.backgroundColor = color

                            self.addTooltip(mark, sentiment)
                        })

                        count++
                    }
                })
            })
        })

        self.clear = function() {
            instance.unmark()
        }

        self.getDocument = function () {
            sentimentService.getDocument(self.content)
        }

        self.getParagraph = function () {
            sentimentService.getParagraph(self.content)
        }

        self.getSentence = function () {
            sentimentService.getSentence(self.content)
        }

        self.getNounsAndAdjectives = function () {
            sentimentService.getNounsAndAdjectives(self.content)
        }

        self.getColorFromSentiment = function (sentiment) {
            return sentimentService.getColorFromSentiment(sentiment)
        }

        self.changeColorByClass = function (className, sentiment) {
            var marks = document.getElementsByClassName(className)

            var color = sentimentService.getColorFromSentiment(sentiment)

            for (var i = 0; i < marks.length; i++) {
                var mark = marks[i]

                mark.style.backgroundColor = color

                self.addTooltip(mark, sentiment)
            }
        }

        self.addTooltip = function (mark, sentiment) {
            mark.classList.add("tooltip")

            mark.setAttribute("data-tooltip", sentimentService.getTooltip(sentiment))
        }

    </script>

    <style>
        .context {
            white-space: pre-line;
        }
    </style>

</entry-content>