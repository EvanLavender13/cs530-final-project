<entry-list>

    <aside class="menu">

        <p class="menu-label">Year</p>
        <ul id="years" class="menu-list">
            <li each={ years }><a href="#dash/entries/{ year }">{ year }</a></li>
        </ul>

        <p class="menu-label">Month</p>
        <ul id="months" class="menu-list">
            <li each={ months }><a href="#dash/entries/{ years[0].year }/{ month }">{ month }</a>
            </li>
        </ul>

        <p class="menu-label">Day</p>
        <ul id="days" class="menu-list">
            <li each={ days }><a href="#dash/entries/{ years[0].year }/{ months[0].month }/{ day }">{ day }</a></li>
        </ul>

    </aside>

    <script>
        var self = this

        this.on("mount", function () {
            route("/dash/entries")

            entryService.show()
        })

        entryService.on("show", function (years) {
            self.years = years
            self.months = []
            self.days = []
            self.update()
        })

        entryService.on("showYear", function (year, months) {
            self.years = [{year: year}]
            self.months = months
            self.days = []
            self.update()
        })

        entryService.on("showMonth", function (year, month, days) {
            self.years = [{year: year}]
            self.months = [{month: month}]
            self.days = days
            self.update()
        })

        entryService.on("showDay", function (year, month, day) {
            self.years = [{year: year}]
            self.months = [{month: month}]
            self.days = [{day: day}]
            self.update()
        })

    </script>

    <style>
        li {
            display: inline-block;
        }
    </style>

</entry-list>