# dashing.js is located in the dashing framework
# It includes jquery & batman for you.
#= require dashing.js

#= require_directory .
#= require_tree ../../widgets

console.log("Yeah! The dashboard has started!")

Batman.Filters.shortenedBytes = (num) ->
  return num if isNaN(num)
  if num >= 1000000000
    (num / 1000000000).toFixed(1) + 'G'
  else if num >= 1000000
    (num / 1000000).toFixed(1) + 'M'
  else if num >= 1000
    (num / 1000).toFixed(1) + 'K'
  else
    num

Dashing.on 'ready', ->
  Dashing.debugMode = true
  Dashing.widget_margins ||= [5, 5]
  Dashing.widget_base_dimensions ||= [240, 300]
  Dashing.numColumns ||= 5

  contentWidth = (Dashing.widget_base_dimensions[0] + Dashing.widget_margins[0] * 2) * Dashing.numColumns

  Batman.setImmediate ->
    $('.gridster').width(contentWidth)
    $('.gridster ul:first').gridster
      widget_margins: Dashing.widget_margins
      widget_base_dimensions: Dashing.widget_base_dimensions
      avoid_overlapped_widgets: !Dashing.customGridsterLayout
      draggable:
        stop: Dashing.showGridsterInstructions
