class Dashing.Weather extends Dashing.Widget

  @accessor 'location', ->
    @get('weather').location.name

  @accessor 'current_temperature', ->
    @get('weather').temperature.current
