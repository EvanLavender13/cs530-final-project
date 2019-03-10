<entries>

    <virtual if={ show }>
        <div class="container">
            <div class="columns">
                <div class="column is-one-fifth">
                    <entry-list/>
                </div>

                <div class="column">
                    <entry-content/>
                </div>

            </div>
        </div>
    </virtual>

    <script>
        var self = this

        var localRoute = route.create()

        localRoute(function () {
            self.show = false
            self.update()
        })

        localRoute("/dash/entries", function () {
            self.show = true
            entryService.show()
            self.update()
        })

        localRoute("/dash/entries/*", function (year) {
            self.show = true
            entryService.showYear(year)
            self.update()
        })

        localRoute("/dash/entries/*/*", function (year, month) {
            self.show = true
            entryService.showMonth(year, month)
            self.update()
        })

        localRoute("/dash/entries/*/*/*", function (year, month, day) {
            self.show = true
            entryService.showDay(year, month, day)
            self.update()
        })

    </script>

</entries>