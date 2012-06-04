redis = require("redis")
client = redis.createClient()
_ = require("underscore")
async = require("async")


module.exports = msgdb = 
    getMsgs: (start = 0, end = 20, onComplete = ->) ->
        msgData = []
        client.LRANGE "msgs", start, end, (e, msgs) ->
            async.forEachSeries(msgs, ((mkey, cb) ->
                client.hgetall mkey, (e, msg) ->
                    if msg?
                        msg.id = mkey
                        msgData.push(msg)
                    else
                        client.LREM "msgs", 0, mkey

                    cb()
            ), -> onComplete(msgData))

    addMsg: (data, onComplete = ->) ->
        client.hset data.key, "subject", data.subject
        client.hset data.key, "from", data.from
        client.hset data.key, "date", data.date
        client.hset data.key, "msg", data.msg
        client.expire data.key, 3600
        client.lpush "msgs", data.key, (e, r) -> onComplete(true)

        client.set data.key + "_raw", data.raw
        client.expire data.key + "_raw", 3600

    getRaw: (msg_id, onComplete = ->) ->
        client.get msg_id + "_raw", (e, raw) -> onComplete(raw)