Rect = (props) -> {
  tag: 'Rect'
  x: 0
  y: 0
  width: 10
  height: 10
  color: 'black'
  props...
}

Label = (props) -> {
  tag: 'Label'
  x: 0
  y: 0
  color: 'black'
  text: ''
  align: 'center'
  vAlign: 'middle'
  props...
}

start = (init, tick, draw) ->
  load = () ->
    canvas = document.createElement 'canvas'
    ctx = canvas.getContext '2d'
    config =
      width: canvas.width
      height: canvas.height
    state = init config
    input =
      left: false
      right: false
      enter: false
    inputMap =
      ArrowLeft: 'left'
      ArrowRight: 'right'
      Enter: 'enter'
    window.onkeydown = (e) ->
      if e.key of inputMap
        input = {
          input...
          "#{inputMap[e.key]}": true
        }
    window.onkeyup = (e) ->
      if e.key of inputMap
        input = {
          input...
          "#{inputMap[e.key]}": false
        }
    document.body.append canvas
    animate = () ->
      state = tick config, state, input
      output = draw config, state
      ctx.fillStyle = '#eee'
      ctx.clearRect 0, 0, canvas.width, canvas.height
      for node in output
        switch node.tag
          when 'Rect'
            ctx.fillStyle = node.color
            ctx.fillRect node.x, node.y, node.width, node.height
          when 'Label'
            ctx.fillStyle = node.color
            ctx.textAlign = node.align
            ctx.textBaseline = node.vAlign
            ctx.fillText node.text, node.x, node.y
      requestAnimationFrame animate
    requestAnimationFrame animate
  if document.readyState is 'interactive'
    load()
  else
    addEventListener 'DOMContentLoaded', load
