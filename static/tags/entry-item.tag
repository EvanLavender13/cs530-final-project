<entry-item>

    <div class="button" onclick={display}>{ entry.date.format("MM/DD/YYYY") }</div>

    <script>
        var self = this

        self.display = function () {
            route("/dash/entries/" + self.entry.id)
        }
    </script>

</entry-item>