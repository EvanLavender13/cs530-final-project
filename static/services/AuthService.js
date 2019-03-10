function AuthService() {
    var self = riot.observable(this)

    qwest.setDefaultDataType('json');

    var user = null
    var localRoute = route.create()

    localRoute(function() {
        self.status()
    })

    self.isLoggedIn = function() {
        return user
    }

    self.register = function (params) {
        qwest.post("api/register", params)
            .then(function (xhr, response) {
                if (response.result === "success") {
                    self.trigger("login", user = true)
                } else {
                    user = false
                }
            })
            .catch(function (e, xhr, response) {
                user = false
                console.log(e)
                console.log(response)
            });
    }

    self.login = function (params) {
        qwest.post("api/login", params)
            .then(function (xhr, response) {
                if (response.result) {
                    self.trigger("login", user = true)
                } else {
                    user = false
                }
            })
            .catch(function (e, xhr, response) {
                user = false
                console.log(e)
                console.log(response)
            });
    }

    self.logout = function () {
        qwest.get("api/logout")
            .then(function (xhr, response) {
                if (response.result) {
                    user = false
                    self.trigger("logout")
                } else {
                    user = false
                }
            })
            .catch(function (e, xhr, response) {
                user = false
                console.log(e)
                console.log(response)
            });
    }

    self.status = function () {
        qwest.get("api/status")
            .then(function (xhr, response) {
                if (response.status) {
                    user = true
                    self.trigger("status", user)
                } else {
                    user = false
                }
            })
            .catch(function (e, xhr, response) {
                user = false
                console.log(e)
                console.log(response)
            });
    }
}