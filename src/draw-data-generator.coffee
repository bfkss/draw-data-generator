# needs D3.js installed and initialized
class DrawDataGenerator

  constructor: (@parent = 'body', @width = 900, @height = 810) ->
    if not d3
      console.error 'you need d3.js to use the data-generator'
      return

    self = this
    @data = []
    @latLngData = []
    @scagnosticsData = {points: []}

    d3.select('body').style('background-color', 'grey')
    svg = d3.select(@parent).append('svg')
      .attr(
        width:
          @width
        height:
          @height
        ).style 'border', '1px solid darkgray'

    @g = svg.append 'g'

    svg.on 'mousemove', () ->
      self.pos = d3.mouse this
      # self.data.push d3.mouse this
      if d3.event.shiftKey and not @interval
        @interval = setInterval ->
          self.draw()
        , 100
      else if not d3.event.shiftKey and @interval
        clearInterval @interval
        @interval = null

    document.onkeypress = (e) =>
      if e.which is 32
        @printPxData()
        @convertToLatLngData()
        @convertToGeoJSON()
        @convertToScagnosticsData()

  draw: () ->
    @data.push @pos

    @g.selectAll 'circle'
      .data @data
      .enter().append 'circle'
      .attr(
        cx:
          (d) ->
            d[0]
        cy:
          (d) ->
            d[1]
        r:
          5
        fill:
          'blue'
        opacity:
          .3
        stroke:
          'darkblue'
      )

  clear: () ->
    @data = []
    @g.selectAll 'circle'
      .data []
      .exit().remove()

  convertToLatLngData: () ->
    for pos in @data
      x = pos[0]
      y = pos[1]
      @latLngData.push [Math.round10(-(y - (@height / 2)) * ( 180 / @height ), -4), Math.round10((x - (@width / 2)) * ( 360 / @width ), -4)]

    console.log 'latLng-data output:'
    console.log @latLngData

    file = document.createElement 'a'
    file.download = 'latLng.json'
    file.textContent = 'lat-lng file'
    file.href = 'data:application/json;base64,'+window.btoa(unescape(encodeURIComponent(JSON.stringify(@latLngData))))

    document.body.appendChild(file)
    document.body.appendChild document.createElement 'br'

  convertToGeoJSON: () ->
    @geoJSON =
      type: "FeatureCollection"
      features: []

    for pos in @data
      x = pos[0]
      y = pos[1]
      feature =
        type: "Feature"
        geometry:
          type: "Point"
          coordinates: [Math.round10((x - (@width / 2)) * ( 360 / @width ), -4), Math.round10(-(y - (@height / 2)) * ( 180 / @height ), -4)]

      @geoJSON.features.push feature

    console.log 'GeoJSON output:'
    console.log @geoJSON

    file = document.createElement 'a'
    file.download = 'geoJSON.json'
    file.textContent = 'GeoJSON file'
    file.href = 'data:application/json;base64,'+window.btoa(unescape(encodeURIComponent(JSON.stringify(@geoJSON))))

    document.body.appendChild(file)
    document.body.appendChild document.createElement 'br'

  convertToScagnosticsData: () ->
    for pos in @data
      x = pos[0]
      y = pos[1]
      @scagnosticsData.points.push {x: x, y: y}

    console.log 'scagnostics-data output:'
    console.log @scagnosticsData

    file = document.createElement 'a'
    file.download = 'scagnosticsData.json'
    file.textContent = 'scagnostics-data file'
    file.href = 'data:application/json;base64,'+window.btoa(unescape(encodeURIComponent(JSON.stringify(@scagnosticsData))))

    document.body.appendChild(file)
    document.body.appendChild document.createElement 'br'

  printPxData: () ->
    console.log 'pixel-data output:'
    console.log @data

    file = document.createElement 'a'
    file.download = 'pixelData.json'
    file.textContent = 'pixel-data file'
    file.href = 'data:application/json;base64,'+window.btoa(unescape(encodeURIComponent(JSON.stringify(@data))))

    document.body.appendChild(file)
    document.body.appendChild document.createElement 'br'
