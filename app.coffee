express = require "express"
app = express()
io = require "socket.io"

app.set "views", __dirname+"/views"
app.set "view engine","jade"
app.use express.static(__dirname + '/public')


app.get "/" ,(req,res)->
    res.render "index"

server = app.listen 3000
io = io.listen server
io.sockets.on "connection",(socket)->
  console.log "connected"
  socket.on "enter", (data) ->
    console.log data
    socket.emit "data",data
    socket.join data.aikotoba
  socket.on "update",(data) ->
    socket.broadcast.to(data.aikotoba).emit "data",data
