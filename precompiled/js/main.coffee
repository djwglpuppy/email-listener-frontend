class MessageView extends Backbone.View
    tagName: "div"
    initialize: (@model) ->
    render: ->
        @$el.html(main.templates.msg(@model.toJSON()))


class Msg extends Backbone.Model
    render: -> new MessageView(@).render()


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