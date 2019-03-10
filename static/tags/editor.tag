<editor>

    <virtual if={ show }>
        <div class="container">
            <div id="editor"></div>
        </div>
        <div class="container">
            <form onsubmit={ save }>
                <div class="field">
                    <div class="control">
                        <input class="button is-primary" type="submit" value="Save">
                    </div>
                </div>
            </form>
        </div>

    </virtual>

    <script>
        var self = this

        var localRoute = route.create()

        self.quill = null

        localRoute(function () {
            self.show = false
            self.update()
        })

        localRoute("/dash/new", function () {
            self.show = true
            self.update()

            self.quill = new Quill("#editor", {
                modules: {
                    toolbar: []
                },
                placeholder: "Write something...",
                theme: "snow"  // or "bubble"
            });
        })

        entryService.on("add", function (year, month, day) {
            route("/dash/entries/" + year + "/" + month + "/" + day)
        })

        self.save = function (e) {
            e.preventDefault()

            var text = self.quill.getText()

            var date = dayjs()

            var year = date.format("YYYY")
            var month = date.format("M")
            var day = date.format("D")

            entryService.addEntry(year, month, day, text)
        }

    </script>

</editor>