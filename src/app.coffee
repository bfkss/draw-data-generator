# @codekit-prepend "../bower_components/d3/d3.min.js"
# @codekit-prepend "draw-data-generator.coffee"

# optionally you may give the width and height in the parameters: ('main', 900, 810)
DG = new DrawDataGenerator('main', document.body.clientWidth, document.documentElement.clientHeight - 22)
