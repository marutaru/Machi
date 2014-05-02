$ ->

  #
  # initialize
  #
  lat = null
  long = null
  roomName = null
  map = null
  markerManager = []
  myMarker = null
  flag = false
  $("#update").hide()

  # geolocation
  opt =
    enableHighAccuracy:true
    timeout:10000
    maximumAge:0
  navigator.geolocation.watchPosition (position) ->
    lat = position.coords.latitude
    long = position.coords.longitude
    $("#lat").val(lat)
    $("#long").val(long)
    info =
      "name":$("#username").val()
      "aikotoba":$("#aikotoba").val()
      "lat":lat
      "long":long
    if flag is true
      moveMarker(info,myMarker)
      socket.emit "update",info
  ,(error) ->
    console.log error
  ,(opt)

  # socket connect
  socket = io.connect "http://localhost:3000"

  # map init
  mapInit = () ->
    option =
      "center": new google.maps.LatLng lat,long
      "zoom":12
      "mapTypeId": google.maps.MapTypeId.ROADMAP
    map = new google.maps.Map $("#map_canvas").get(0),option
    console.log "initilized maps"

  # join button
  $("#join").click (event) ->
    flag = true
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
    socket.emit "join",my
    # button change
    $(this).hide()
    $("#update").show()

  # update button
  # @todo delte
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
    console.log "data update"
    roomName = data.aikotoba
    latlng = new google.maps.LatLng data.lat,data.long
    if oldMarker = _.findWhere(markerManager,"title":data.name)
      moveMarker(data,oldMarker)
    else
      newMarker(data)
      info =
        "name":$("#username").val()
        "aikotoba":$("#aikotoba").val()
        "lat":lat
        "long":long
      socket.emit "update",info

  #
  # functions
  #

  # make Marker
  newMarker = (data) ->
    latlng = new google.maps.LatLng data.lat,data.long
    marker = new google.maps.Marker
      "position":latlng
      "map":map
      "title":data.name
    markerManager.push marker
  # move Marker
  moveMarker = (data,marker) ->
    console.log "moveMarker"
    console.log marker
    latlng = new google.maps.LatLng data.lat,data.long
    marker.position = latlng
    marker.setMap map
