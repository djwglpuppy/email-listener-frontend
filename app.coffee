devport = 9100
express = require("express")
RedisStore = require('connect-redis')(express)
redisdb = require("./redis")
emaillistener = require("email-listener")

app = express.createServer(
    express.bodyParser(),
    express.cookieParser(),
    express.session({secret: "thisisnotthesecretyouarelookingfor",  store: new RedisStore})
)

app.configure ->
    @set('views', __dirname + '/views')
    @set('view engine', 'jade')

app.configure "development", ->

    @use(require("coffee-middle")({
        src: __dirname + "/precompiled/js"
        dest: __dirname + "/static/js"
        browserReload: false
    }))

    @use(require("stylus").middleware({
        src: __dirname + "/precompiled"
        dest: __dirname + "/static"
        compress: true
    }))

    @use(express.static(__dirname + '/static'))
    @use(this.router)

app.configure "production", ->
    @use(express.static(__dirname + '/static'))
    @use(this.router)
    

require("./routes")(app)

if app.settings.env is "development"
    app.listen(devport)
    console.log "Started on port #{devport} in Development Mode"
    emaillistener.start(8888)
else
    app.listen(8000)
    console.log "Started on port 8000 in Production Mode"
    emaillistener.start()


###
# Email Listener
###

emaillistener.on "msg", (recipient, body, parsed) ->

    return false if recipient isnt "tester@nodejs.io"
    newBody = body.replace(/@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+/gi, '@___.site')

    now = new Date()

    redisdb.addMsg {
        key: now.getTime()
        subject: parsed.subject
        from: parsed.from[0].name
        date: now
        raw: newBody
        msg: if parsed.html? then parsed.html.replace(/@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+/gi, '@___.site') else parsed.text.replace(/@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+/gi, '@___.site')
    }


