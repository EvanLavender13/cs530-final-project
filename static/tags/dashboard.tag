<dashboard>

    <virtual if={ show }>
        <div class="section">
            <div class="tabs is-large">
                <ul>
                    <li><a href="#dash/new">New</a></li>
                    <li><a href="#dash/entries">Entries</a></li>
                    <li><a href="#dash/summary">Summary</a></li>
                    <li><a href="#dash/data">Data</a></li>
                </ul>
            </div>
        </div>

        <div class="section">
            <entries/>
            <editor/>
            <summary/>
            <data-view/>
        </div>
    </virtual>

    <script>
        var self = this

        var localRoute = route.create()

        localRoute(function () {
            self.show = false
            self.update()
        })

        localRoute("/dash..", function () {
            if (!authService.isLoggedIn()) {
                route("/")
            } else {
                self.show = true
                self.update()
            }
        })

        authService.on("logout", function() {
            route("/")
        })
    </script>

</dashboard>