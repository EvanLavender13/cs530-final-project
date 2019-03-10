<data-view>

    <virtual if={ show }>

        <div class="container">
            <div class="columns">
                <div class="column is-four-fifths">
                    <canvas id="myChart"></canvas>
                </div>

                <div class="column">
                    <div class="field">
                        <input class="is-checkradio" id="total" type="radio" name="words"
                               checked="checked" onclick={radioButton}>
                        <label for="total">Total</label>
                    </div>

                    <virtual each={ word in words }>
                        <div class="field">
                            <input class="is-checkradio" id={ word } type="radio"
                                   name="words" onclick={radioButton}>
                            <label for={ word }>{ word }</label>
                        </div>
                    </virtual>
                </div>

            </div>
        </div>

    </virtual>

    <script>
        var self = this

        var localRoute = route.create()

        self.months = ["January", "February", "March", "April", "May", "June", "July",
            "August", "September", "October", "November", "December"]

        self.words = []

        self.chart = null
        self.wordData = null

        self.totalDataSets = []
        self.wordDataSets = {}

        self.compoundData = []
        self.positiveData = []
        self.neutralData = []
        self.negativeData = []

        localRoute(function () {
            self.show = false
            self.update()
        })

        localRoute("/dash/data", function () {
            self.show = true
            self.update()

            dataService.getData(2019)
            dataService.getDataWords(2019)
        })

        dataService.on("data", function (data) {
            var labels = []

            Object.keys(data).forEach(function (index) {
                dataPoint = data[index]

                labels.push(self.months[index - 1])

                self.compoundData.push({
                    "x": index,
                    "y": dataPoint["compound"]
                })

                self.positiveData.push({
                    "x": index,
                    "y": dataPoint["positive"]
                })

                self.neutralData.push({
                    "x": index,
                    "y": dataPoint["neutral"]
                })

                self.negativeData.push({
                    "x": index,
                    "y": dataPoint["negative"]
                })
            })

            self.totalDataSets = [{
                label: "Compound Avg.",
                backgroundColor: "rgba(0, 0, 0, 0.5)",
                borderColor: "rgba(0, 0, 0, 0.5)",
                data: self.compoundData,
                fill: false
            }, {
                label: "Positive Avg.",
                backgroundColor: "rgba(0, 255, 0, 0.5)",
                borderColor: "rgba(0, 255, 0, 0.5)",
                data: self.positiveData,
                fill: false
            }, {
                label: "Neutral Avg.",
                backgroundColor: "rgba(0, 0, 255, 0.5)",
                borderColor: "rgba(0, 0, 255, 0.5)",
                data: self.neutralData,
                fill: false
            }, {
                label: "Negative Avg.",
                backgroundColor: "rgba(255, 0, 0, 0.5)",
                borderColor: "rgba(255, 0, 0, 0.5)",
                data: self.negativeData,
                fill: false
            }]

            var ctx = document.getElementById("myChart").getContext("2d");
            self.chart = new Chart(ctx, {
                type: "line",
                data: {
                    labels: labels,
                    datasets: self.totalDataSets
                },
                options: null
            });
        })

        dataService.on("dataWord", function (data) {
            self.wordData = data

            Object.keys(data).forEach(function (month) {
                Object.keys(data[month]).forEach(function (key) {
                    if (self.words.indexOf(key) < 0) {
                        self.words.push(key)
                    }

                    var wordData = self.wordDataSets[key]
                    if (!wordData) {
                        wordData = {
                            "compound": [],
                            "positive": [],
                            "neutral": [],
                            "negative": []
                        }
                    }

                    wordData["compound"].push({
                        "x": month,
                        "y": data[month][key]["compound"]
                    })

                    wordData["positive"].push({
                        "x": month,
                        "y": data[month][key]["positive"]
                    })

                    wordData["neutral"].push({
                        "x": month,
                        "y": data[month][key]["neutral"]
                    })

                    wordData["negative"].push({
                        "x": month,
                        "y": data[month][key]["negative"]
                    })

                    self.wordDataSets[key] = wordData
                })
            })

            console.log(self.wordDataSets)

            self.update()
        })

        self.radioButton = function (event) {
            var id = event.target.id

            if (id === "total") {
                self.chart.data.datasets = self.totalDataSets
            } else {
                var dataSet = self.wordDataSets[id]

                self.chart.data.datasets[0].data = dataSet["compound"]
                self.chart.data.datasets[1].data = dataSet["positive"]
                self.chart.data.datasets[2].data = dataSet["neutral"]
                self.chart.data.datasets[3].data = dataSet["negative"]
            }


            self.chart.update()
            self.update()
        }

    </script>

</data-view>