$ ->

  # initialize
  lat = 35
  long = 140
  roomname = null
  map = null
  makerManager = []
  navigator.geolocation.getCurrentPosition (position) ->
    lat = position.coords.latitude
    long = position.coords.longitude
  ,(error) ->
    console.log error
  $("#update").hide()

  # socket connect
  socket = io.connect "http://localhost:3000"

  # join button
  $("#join").click (event) ->
    info =
      "name":$("#username").val()
      "aikotoba":$("#aikotoba").val()
      "lat":lat
      "long":long
    console.log "click"+info.name
    init()
    latlng = new google.maps.LatLng lat,long
    marker = new google.maps.Marker
      "position":latlng
      "map":map
    socket.emit "enter", info
    $(this).hide()
    $("#update").show()

  # map init
  init = () ->
    myOptions =
      "center": new google.maps.LatLng(lat,long)
      "zoom":15
      "mapTypeId": google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map $("#map_canvas").get(0),myOptions
    console.log "maps init"

  # update button
  $("#update").click (event) ->
    console.log "update"
    info =
      "name":$("#username").val()
      "aikotoba":$("#aikotoba").val()
      "lat":lat
      "long":long
    socket.emit "update",info

  # data update
  socket.on "data", (data) ->
    roomname = data.aikotoba
    $("#roomname").append "<div>"+data.aikotoba+"</div>"
    $("#userinfo").append "<div>"+data.name+"</div>"+"<div>"+data.lat+"</div>"+"<div>"+data.long+"</div>"
