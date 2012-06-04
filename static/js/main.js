var Main, MessageView, Msg, Msgs, main,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

MessageView = (function(_super) {

  __extends(MessageView, _super);

  function MessageView() {
    return MessageView.__super__.constructor.apply(this, arguments);
  }

  MessageView.prototype.tagName = "div";

  MessageView.prototype.events = {
    "click .message .link": "viewRaw",
    "click .raw .link": "viewMessage"
  };

  MessageView.prototype.render = function() {
    return this.$el.html(main.templates.msg(this.model.toJSON()));
  };

  MessageView.prototype.viewRaw = function() {
    var viewer,
      _this = this;
    viewer = function() {
      _this.$el.find(".message").hide();
      return _this.$el.find(".raw").fadeIn(300);
    };
    if (!(this.model.get("raw") != null)) {
      return this.model.rawData(function(raw) {
        _this.$el.find(".raw .body pre").text("" + raw);
        return viewer();
      });
    } else {
      return viewer();
    }
  };

  MessageView.prototype.viewMessage = function() {
    this.$el.find(".raw").hide();
    return this.$el.find(".message").fadeIn(300);
  };

  return MessageView;

})(Backbone.View);

Msg = (function(_super) {

  __extends(Msg, _super);

  function Msg() {
    return Msg.__super__.constructor.apply(this, arguments);
  }

  Msg.prototype.emailConvert = function() {
    var email, from;
    from = this.get("from").match(/\<(.*)\>/);
    email = from != null ? from[1] : this.get("from");
    return this.set("from", email);
  };

  Msg.prototype.dateConvert = function() {
    var d, hours, mer, newDate, newTime;
    d = new Date(this.get("date"));
    newDate = [d.getMonth() + 1, d.getDate(), d.getFullYear()].join("-");
    hours = d.getHours();
    mer = "am";
    if (hours === 0) {
      newTime = 12;
    }
    if (hours < 12 && hours !== 0) {
      newTime = hours;
    }
    if (hours > 12) {
      newTime = hours - 12;
    }
    if (hours >= 12) {
      mer === "pm";
    }
    newTime += ":" + d.getMinutes() + mer;
    return this.set("date", newDate + " " + newTime);
  };

  Msg.prototype.initialize = function() {
    this.emailConvert();
    return this.dateConvert();
  };

  Msg.prototype.render = function() {
    return new MessageView({
      model: this
    }).render();
  };

  Msg.prototype.rawData = function(onComplete) {
    var _this = this;
    return $.get("/rawdata/" + this.id, function(rawdata) {
      _this.set("raw", rawdata);
      return onComplete(_this.get("raw"));
    });
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
