function EntryService() {
    var self = riot.observable(this)

    qwest.setDefaultDataType("json");

    self.show = function () {
        qwest.get("api/year")
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("show", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.showYear = function (year) {
        qwest.post("api/month", {"year": year})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("showYear", year, response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.showMonth = function (year, month) {
        qwest.post("api/day", {"year": year, "month": month})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("showMonth", year, month, response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.showDay = function (year, month, day) {
        qwest.post("api/day", {"year": year, "month": month, "day": day})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("showDay", year, month, day,
                        {"content": response.data})
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });


    }

    self.addEntry = function (year, month, day, content) {
        qwest.post("api/add", {"year": year, "month": month, "day": day, "content": content})
            .then(function (xhr, response) {
                if (response.result === "success") {
                    console.log(response)
                    self.trigger("add", year, month, day)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }


}