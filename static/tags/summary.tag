<summary>

    <virtual if={ show }>

        <div id="calendar" class="container">
            <calendar/>
        </div>

    </virtual>

    <script>
        var self = this

        var localRoute = route.create()

        localRoute(function () {
            self.show = false
            self.update()
        })

        localRoute("/dash/summary", function () {
            self.show = true
            self.update()

        })
    </script>


</summary>