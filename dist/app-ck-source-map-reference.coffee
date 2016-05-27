`var requestScagnostics = function(data, done) {
  var url = 'http://localhost:8084/Scagnostics/rest/scagnostics_service/scagnostics'

  var xhr = new XMLHttpRequest()

  xhr.open('POST', url)
  xhr.setRequestHeader("Content-Type", "application/json")
  xhr.onload = function() {
    if (xhr.status >= 200 && xhr.status < 300) {
      done(JSON.parse(xhr.response))
    } else {
      done({
        status: xhr.status,
        statusText: xhr.statusText
      })
    }
  }
  xhr.onerror = function() {
    done({
      status: xhr.status,
      statusText: xhr.statusText
    })
  }
  xhr.send(data)
}
`

class DrawDataGenerator

  constructor: (@parent = 'body', @width = 900, @height = 810) ->
    self = this
    @frequency = 100
    @data = []
    @latLngData = []
    @scagnosticsData = {points: []}
    @downloads = document.getElementById 'downloads'
    @scag = d3.select '#scag table'

    svg = d3.select(@parent).append('svg')
      .attr(
        width:
          @width - 350
        height:
          @height
      ).style(
        border: '1px solid darkgray'
        display: 'inline-block'
      )

    @g = svg.append 'g'

    svg.on 'mousemove', () ->
      self.pos = d3.mouse this
      # self.data.push d3.mouse this
      if d3.event.shiftKey and not @interval
        @interval = setInterval ->
          self.draw()
        , self.frequency
      else if not d3.event.shiftKey and @interval
        clearInterval @interval
        @interval = null

    document.onkeypress = (e) =>
      if e.which is 32
        @clear()
        @printPxData()
        @convertToLatLngData()
        @convertToGeoJSON()
        @convertToScagnosticsData()
        @getScagnostics()

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
    # @data = []
    # @g.selectAll 'circle'
    #   .data []
    #   .exit().remove()
    d3.selectAll 'a, br'
      .remove()

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

    @downloads.appendChild(file)
    @downloads.appendChild document.createElement 'br'

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

    @downloads.appendChild(file)
    @downloads.appendChild document.createElement 'br'

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

    @downloads.appendChild(file)
    @downloads.appendChild document.createElement 'br'

  printPxData: () ->
    console.log 'pixel-data output:'
    console.log @data

    file = document.createElement 'a'
    file.download = 'pixelData.json'
    file.textContent = 'pixel-data file'
    file.href = 'data:application/json;base64,'+window.btoa(unescape(encodeURIComponent(JSON.stringify(@data))))

    @downloads.appendChild(file)
    @downloads.appendChild document.createElement 'br'

  getScagnostics: () ->
    requestScagnostics(
      JSON.stringify(@scagnosticsData)
      (data) ->
        console.log data

        dataArray = for prop, val of data
          {
            property: prop,
            value: val
          }

        tr = d3.select('#scag tbody').selectAll('tr')
          .data dataArray
          .html((d) ->
            "<td>#{d.property}</td><td>#{d.value}</td>"
          )

        # tr.style('background-color', '#3fd221')
        #   .transition()
        #     .style('background-color', 'white')

        tr.enter().append 'tr'
          .html((d) ->
            "<td>#{d.property.toLowerCase()}</td><td>#{d.value}</td>"
          )
        tr.exit().remove()

        # td = tr.selectAll 'td'
        #     .data((d) ->
        #       [d.property, d.value]
        #     )
        #     .text((d) ->
        #       d
        #     )
        #
        # td.enter().append('tr')
        #   .text((d) ->
        #     d
        #   )
        # td.exit().remove()
    )


# @codekit-prepend 'ajax.js', 'draw-data-generator.coffee';

# optionally you may give the width and height in the parameters: ('main', 900, 810)
DG = new DrawDataGenerator(
  'main',
  document.body.clientWidth,
  document.documentElement.clientHeight - 22
)

# you may change the draw interval in ms, defaults to 100ms
# DG.frequency = 500


