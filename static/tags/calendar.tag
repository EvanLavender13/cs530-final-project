<calendar>
    <div class="tile is-ancestor">
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">1</p>
                <p class="subtitle">January</p>
                <div id="month-1"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box month-2">
                <p class="title">2</p>
                <p class="subtitle">February</p>
                <div id="month-2"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box month-3">
                <p class="title">3</p>
                <p class="subtitle">March</p>
                <div id="month-3"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">4</p>
                <p class="subtitle">April</p>
                <div id="month-4"></div>
            </article>
        </div>
    </div>

    <div class="tile is-ancestor">
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">5</p>
                <p class="subtitle">May</p>
                <div id="month-5"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">6</p>
                <p class="subtitle">June</p>
                <div id="month-6"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">7</p>
                <p class="subtitle">July</p>
                <div id="month-7"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">8</p>
                <p class="subtitle">August</p>
                <div id="month-8"></div>
            </article>
        </div>
    </div>

    <div class="tile is-ancestor">
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">9</p>
                <p class="subtitle">September</p>
                <div id="month-9"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">10</p>
                <p class="subtitle">October</p>
                <div id="month-10"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">11</p>
                <p class="subtitle">November</p>
                <div id="month-11"></div>
            </article>
        </div>
        <div class="tile is-parent">
            <article class="tile is-child box">
                <p class="title">12</p>
                <p class="subtitle">December</p>
                <div id="month-12"></div>
            </article>
        </div>
    </div>

    <script>
        var self = this

        self.on("mount", function () {
            calendarService.getSummary()

            self.update()
        })

        calendarService.on("summary", function (data) {
            for (var i = 1; i <= 12; i++) {
                var firstDay = new Date(2019, i - 1).getDay()

                var daysInMonth = 32 - new Date(2019, i - 1, 32).getDate()

                self.createTable(firstDay, daysInMonth, i)
            }

            Object.keys(data).forEach(function (index) {
                var entry = data[index]

                var month = entry["month"]
                var day = entry["day"]

                var tile = document.getElementById("month-" + month)
                var cell = tile.getElementsByClassName("day-" + day)[0]

                var sentiment = entry["sentiment"]
                var color = sentimentService.getColorFromSentiment(sentiment)

                cell.style.backgroundColor = color

                var tooltip = ""

                var comp = sentiment["compound"]
                if (comp >= 0.05) {
                    // positive
                    tooltip += "+ Positive: " + sentiment["pos"]
                } else if (comp > -0.05 && comp < 0.05) {
                    // neutral
                    console.log("HELLO??")
                    tooltip += "= Neutral: " + sentiment["neu"]
                } else if (comp <= -0.05) {
                    // negative
                    tooltip += "- Negative: " + sentiment["neg"]
                }

                console.log(comp + " " + tooltip)

                cell.setAttribute("data-tooltip", tooltip)
            })
        })

        self.createTable = function (firstDay, daysInMonth, month) {

            // get the specific month tile
            var tag = "month-" + month
            var div = document.getElementById(tag)

            // clear it out!
            div.innerHTML = ""

            // create table element
            var table = document.createElement("table")
            table.className = "table is-narrow is-centered is-fullwidth is-hoverable"

            // create table header
            var days = ["S", "M", "T", "W", "T", "F", "S"]
            var thead = document.createElement("thead")
            var tr = document.createElement("tr")

            Object.keys(days).forEach(function (index) {
                var day = days[index]

                var th = document.createElement("th")
                var text = document.createTextNode(day)

                th.append(text)
                tr.append(th)
            })

            thead.append(tr)

            table.append(thead)

            // create table data
            var tbody = document.createElement("tbody")
            var count = 1

            for (var i = 0; i < 6; i++) {
                var row = document.createElement("tr")

                for (var j = 0; j < 7; j++) {
                    if (count > daysInMonth) {
                        break
                    }

                    if (i === 0 && j < firstDay) {
                        var day = document.createElement("td")
                        var text = document.createTextNode("")

                        day.append(text)
                        row.append(day)
                    } else {
                        var day = document.createElement("td")
                        var text = document.createTextNode("" + count)

                        day.className = "day-" + count + " tooltip is-tooltip-multiline"

                        day.append(text)
                        row.append(day)

                        count++
                    }
                }

                tbody.append(row)
            }

            table.append(tbody)

            div.append(table)
        }
    </script>

</calendar>