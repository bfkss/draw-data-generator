class DataGenerator

  constructor: (@parent = 'body') ->
    if not d3
      console.error 'you need d3.js to use the data-generator'
      return

    self = this
    @data = []
    @latLngData = []
    @width = 900
    @height = 810

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

    document.onkeypress = (e) ->
      # console.log self
      if e.which is 32
        # self.clear()
        self.convertData()

  draw: () ->
    @data.push @pos
    # console.log @data
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

  convertData: () ->
    for pos in @data
      x = pos[0]
      y = pos[1]
      @latLngData.push [Math.round10(-(y - (@height / 2)) * ( 180 / @height ), -4), Math.round10((x - (@width / 2)) * ( 360 / @width ), -4)]

    # console.log @data
    console.log "latitude/longitude output:"
    console.log @latLngData

    file = document.createElement 'a'
    file.download = 'latLng.json'
    file.textContent = 'Download'
    file.href = 'data:application/json;base64,'+window.btoa(unescape(encodeURIComponent(JSON.stringify(@latLngData))))

    document.body.appendChild(file)


    # function dl(array,filename){
    #   var b=document.createElement('a');
    #   b.download=filename;
    #   b.textContent=filename;
    #   b.href='data:application/json;base64,'+window.btoa(unescape(encodeURIComponent(JSON.stringify(array))))
    #   return b
    # }
    #
    # document.body.appendChild(dl(array,'my.json'));

  # document.onkeydown = (e) ->
  #   @charCode = e.keyCode || e.which
  #   # draw data-points while space is pressed
  #   # if charCode is 32
  #   #   # console.log 'pressed space'
  #   #   document.onmousemove = (me) ->
  #   #     console.log me
  #
  # document.onkeyup = (e) ->
  #   @charCode = null
