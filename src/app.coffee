# @codekit-prepend 'ajax.js', 'draw-data-generator.coffee';

# optionally you may give the width and height in the parameters: ('main', 900, 810)
DG = new DrawDataGenerator(
  'main',
  document.body.clientWidth,
  document.documentElement.clientHeight - 22
)

# you may change the draw interval in ms, defaults to 100ms
# DG.frequency = 500
