var Main, MessageView, Msg, Msgs, main,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MessageView = (function(_super) {

  __extends(MessageView, _super);

  function MessageView() {
    return MessageView.__super__.constructor.apply(this, arguments);
  }

  MessageView.prototype.tagName = "div";

  MessageView.prototype.initialize = function(model) {
    this.model = model;
  };

  MessageView.prototype.render = function() {
    return this.$el.html(main.templates.msg(this.model.toJSON()));
  };

  return MessageView;

})(Backbone.View);

Msg = (function(_super) {

  __extends(Msg, _super);

  function Msg() {
    return Msg.__super__.constructor.apply(this, arguments);
  }

  Msg.prototype.render = function() {
    return new MessageView(this).render();
  };

  return Msg;

})(Backbone.Model);

Msgs = (function(_super) {

  __extends(Msgs, _super);

  function Msgs() {
    return Msgs.__super__.constructor.apply(this, arguments);
  }

  Msgs.prototype.model = Msg;

  Msgs.prototype.render = function() {
    $("#messages").empty();
    return this.each(function(msg) {
      return $("#messages").append(msg.render());
    });
  };

  return Msgs;

})(Backbone.Collection);

Main = (function(_super) {

  __extends(Main, _super);

  function Main() {
    return Main.__super__.constructor.apply(this, arguments);
  }

  Main.prototype.el = "body";

  Main.prototype.templates = {
    msg: null
  };

  Main.prototype.start = function() {
    this.templates.msg = Handlebars.compile($("#msg-tpl").html());
    return new Msgs(MSGS).render();
  };

  return Main;

})(Backbone.View);

main = new Main;

$(function() {
  return main.start();
});
