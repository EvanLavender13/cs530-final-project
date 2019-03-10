<navbar>

    <nav class="navbar" role="navigation" aria-label="main navigation">
        <div class="navbar-brand">
            <div class="navbar-brand">
                <a class="navbar-item" href="#">
                    <i class="fas fa-pizza-slice"></i>
                </a>

                <a role="button" class="navbar-burger" aria-label="menu" aria-expanded="false">
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                    <span aria-hidden="true"></span>
                </a>
            </div>
        </div>

        <div class="navbar-menu">
            <div class="navbar-end">
                <div class="navbar-item">
                    <div class="buttons">
                        <a if={ !authService.isLoggedIn() } class="button is-primary" href="#login">Log in</a>
                        <a if={ authService.isLoggedIn() } class="button is-primary" onclick={ logout }>Log out</a>
                    </div>
                </div>
            </div>
        </div>
    </nav>

    <script>
        var self = this

        var localRoute = route.create()

        localRoute("/", function () {
            self.update()
        })

        self.logout = function() {
            authService.logout()
        }

        authService.on("login", function() {
            self.update()
        })

        authService.on("logout", function() {
            self.update()
        })

    </script>

</navbar>