$ ->

  # initialize
  # global
  lat = 41
  long = 140
  roomName = null
  map = null
  makerManager = []
  myMarker = null
  $("#update").hide()

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

  # socket connect
  socket = io.connect "http://localhost:3000"

  # join button
  $("#join").click (event) ->
    lat = $("#lat").val()
    long = $("#long").val()
    name = $("#username").val()
    my =
      "name":name
      "aikotoba":$("#aikotoba").val()
      "lat":lat
      "long":long
    console.log "click"+my.name
    mapInit()
    latlng = new google.maps.LatLng lat,long
    myMarker = new google.maps.Marker
      "position":latlng
      "map":map
      "title":name
    socket.emit "enter",my
    # button change
    $(this).hide()
    $("#update").show()

  # map init
  mapInit = () ->
    option =
      "center": new google.maps.LatLng lat,long
      "zoom":10
      "mapTypeId": google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map $("#map_canvas").get(0),option
    console.log "initilized maps"

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
    moveMarker(info,myMarker)
    socket.emit "update",info

  # data update
  socket.on "data", (data) ->
    roomName = data.aikotoba
    latlng = new google.maps.LatLng data.lat,data.long
    newMarker(data)

  # make Marker
  newMarker = (data) ->
    latlng = new google.maps.LatLng data.lat,data.long
    marker = new google.maps.Marker
      "position":latlng
      "map":map
      "title":data.name
  # move Marker
  moveMarker = (data,marker) ->
    latlng = new google.maps.LatLng data.lat,data.long
    marker.position = latlng
    marker.setMap map
