<splash>

    <virtual if={show}>
        <section class="hero is-primary is-bold is-fullheight-with-navbar">
            <div class="hero-body">
                <div class="container has-text-centered">
                    <a class="button" href="#/signup">Sign up</a>
                </div>
            </div>
        </section>
    </virtual>

    <script>
        var self = this

        var localRoute = route.create()

        localRoute(function () {
            self.show = false
            self.update()
        })

        localRoute("/", function () {
            if (authService.isLoggedIn()) {
                route("/dash")
            } else {
                self.show = true
                self.update()
            }
        })
    </script>

</splash>