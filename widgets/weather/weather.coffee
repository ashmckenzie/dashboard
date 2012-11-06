class Dashing.Weather extends Dashing.Widget

  @accessor 'location', ->
    @get('weather').location.name

  @accessor 'current', ->
    @get('weather').temperature.today.current

  @accessor 'today_high', ->
    @get('weather').temperature.today.high

  @accessor 'today_low', ->
    @get('weather').temperature.today.low

  @accessor 'tomorrow_high', ->
    @get('weather').temperature.tomorrow.high

  @accessor 'tomorrow_low', ->
    @get('weather').temperature.tomorrow.low
