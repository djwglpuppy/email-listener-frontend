class MessageView extends Backbone.View
    tagName: "div"
    events: 
        "click .message .link": "viewRaw"
        "click .raw .link": "viewMessage"
    render: ->
        @$el.html(main.templates.msg(@model.toJSON()))

    viewRaw: ->
        viewer = =>
            @$el.find(".message").hide()
            @$el.find(".raw").fadeIn(300)

        if not @model.get("raw")?
            @model.rawData (raw) =>
                @$el.find(".raw .body pre").text("#{raw}")
                viewer()
        else
            viewer()

    viewMessage: ->
        @$el.find(".raw").hide()
        @$el.find(".message").fadeIn(300)


class Msg extends Backbone.Model
    emailConvert: ->
        from = @get("from").match(/\<(.*)\>/)
        email = if from? then from[1] else @get("from")
        @set("from", email)


    dateConvert: ->
        d = new Date(@get("date"))
        newDate = [(d.getMonth() + 1), d.getDate(), d.getFullYear()].join("-")
        hours = d.getHours()
        mer = "am"
        newTime = 12 if hours is 0
        newTime = hours if hours < 12 and hours isnt 0
        newTime = hours - 12 if hours > 12
        mer = "pm" if hours >= 12
        newTime += (":" + d.getMinutes() + mer)
        @set("date", newDate + " " + newTime)

    initialize: ->
        @emailConvert()
        @dateConvert()

    render: -> new MessageView({model: @}).render()

    rawData: (onComplete) ->
        $.get "/rawdata/#{@id}", (rawdata) =>
            @set("raw", rawdata)
            onComplete(@get("raw"))


class Msgs extends Backbone.Collection
    model: Msg
    render: ->
        $("#messages").empty()
        @each (msg) -> $("#messages").append msg.render()


class Main extends Backbone.View
    el: "body"
    templates:
        msg: null
    start: ->
        @templates.msg = Handlebars.compile($("#msg-tpl").html())
        new Msgs(MSGS).render()


main = new Main
$ -> main.start()