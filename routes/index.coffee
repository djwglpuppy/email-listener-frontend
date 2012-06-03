data = require("../redis")

module.exports = (app) ->


    app.get '/', (req, res) ->


        data.getMsgs 0, 20, (msgs) ->
            res.render 'index', 
                title: 'node-email-listener'
                msgs: msgs


