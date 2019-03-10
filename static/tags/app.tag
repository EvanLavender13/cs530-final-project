<app>

    <navbar/>
    <splash/>

    <login/>
    <signup/>
    <dashboard/>

    <script>
        this.on('mount', function () {
            route.start(true)

            authService.status()

            route.exec()
        })

        authService.one("status", function (user) {
            route.exec()
        })
    </script>

</app>