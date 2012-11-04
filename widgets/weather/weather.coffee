class Dashing.Weather extends Dashing.Widget

  @accessor 'location', ->
    @get('weather').location.name

  @accessor 'current_temperature', ->
    @get('weather').temperature.current

  @accessor 'forecast_high', ->
    @get('forecast').high

  @accessor 'forecast_low', ->
    @get('forecast').low
