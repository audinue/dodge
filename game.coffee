intersect = (a, b) ->
  a.x <= b.x + b.width and
  b.x <= a.x + a.width and
  a.y <= b.y + b.height and
  b.y <= a.y + a.height

NewGame = (config) ->
  tag: 'Game'
  player:
    Rect
      x: (config.width - 10) / 2
      y: config.height - 30
      color: 'blue'
  enemies: []
  counter: 0
  score: 0

init = () ->
  tag: 'Title'

tick = (config, state, input) ->
  switch state.tag
    when 'Title', 'GameOver'
      if input.enter
        NewGame config
      else
        state
    when 'Game'
      if state.enemies.some (enemy) -> intersect(enemy, state.player)
        tag: 'GameOver'
        score: state.score
      else
        tag: 'Game'
        player: {
          state.player...
          x:
            if input.left and state.player.x > 0
              state.player.x - 5
            else if input.right and state.player.x < config.width - 10
              state.player.x + 5
            else
              state.player.x
        }
        enemies:
          (
            if state.counter is 20
              [
                state.enemies...
                Rect
                  x: Math.floor Math.random() * (config.width - 10)
                  y: -10
                  color: 'red'
              ]
            else
              state.enemies
          )
          .map (enemy) -> {
            enemy...
            y: enemy.y + 5
          }
          .filter (enemy) ->
            enemy.y <= config.height
        counter:
          if state.counter is 20
            0
          else
            state.counter + 1
        score:
          state.score + (state.enemies.filter (enemy) -> enemy.y >= config.height).length

draw = (config, state) ->
  switch state.tag
    when 'Title'
      [
        Label
          text: 'Dodge'
          x: config.width / 2
          y: config.height / 2 - 10
        Label
          text: 'Press enter to play'
          x: config.width / 2
          y: config.height / 2 + 10
      ]
    when 'Game'
      [
        state.player
        state.enemies...
        Label
          text: state.score
          x: 10
          y: 10
          align: 'left'
          vAlign: 'top'
      ]
    when 'GameOver'
      [
        Label
          text: 'Game Over'
          x: config.width / 2
          y: config.height / 2 - 20
        Label
          text: "Score: #{state.score}"
          x: config.width / 2
          y: config.height / 2
        Label
          text: "Press enter to play again"
          x: config.width / 2
          y: config.height / 2 + 20
      ]

start init, tick, draw
