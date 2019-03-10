function CalendarService() {
    var self = riot.observable(this)

    qwest.setDefaultDataType("json");

    self.getSummary = function () {
        qwest.get("api/summary")
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("summary", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }
}