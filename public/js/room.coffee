$ ->

  # initialize
  lat = 41
  long = 140
  roomName = null
  map = null
  makerManager = []
  myMarker = null

  # geolocation
  ###
  navigator.geolocation.getCurrentPosition (position) ->
    lat = position.coords.latitude
    long = position.coords.longitude
    $("#lat").val(lat)
    $("#long").val(long)
  ,(error) ->
    console.log error
  ###

  $("#update").hide()

  # socket connect
  socket = io.connect "http://localhost:3000"

  # join button
  $("#join").click (event) ->
    lat = $("#lat").val()
    long = $("#long").val()
    info =
      "name":$("#username").val()
      "aikotoba":$("#aikotoba").val()
      "lat":lat
      "long":long
    console.log "click"+info.name
    init()
    latlng = new google.maps.LatLng lat,long
    myMarker = new google.maps.Marker
      "position":latlng
      "map":map
    socket.emit "enter", info
    $(this).hide()
    $("#update").show()

  # map init
  init = () ->
    myOptions =
      "center": new google.maps.LatLng lat,long
      "zoom":12
      "mapTypeId": google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map $("#map_canvas").get(0),myOptions
    console.log "maps init"

  # update button
  $("#update").click (event) ->
    console.log "update"
    lat = $("#lat").val()
    long = $("#long").val()
    info =
      "name":$("#username").val()
      "aikotoba":$("#aikotoba").val()
      "lat":lat
      "long":long
    latlng = new google.maps.LatLng lat,long
    myMarker.position = latlng
    myMarker.setMap map
    socket.emit "update",info

  # data update
  socket.on "data", (data) ->
    roomName = data.aikotoba
    $("#roomname").append "<div>"+data.aikotoba+"</div>"
    $("#userinfo").append "<div>"+data.name+"</div>"+"<div>"+data.lat+"</div>"+"<div>"+data.long+"</div>"
