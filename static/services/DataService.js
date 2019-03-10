function DataService() {
    var self = riot.observable(this)

    qwest.setDefaultDataType("json");

    self.getData = function (year) {
        qwest.post("api/data", {"year": year})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("data", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }

    self.getDataWords = function (year) {
        qwest.post("api/data_word", {"year": year})
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("dataWord", response.data)
                }
            })
            .catch(function (e, xhr, response) {
                console.log(e)
                console.log(response)
            });
    }
}