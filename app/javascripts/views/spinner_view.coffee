# simple_gradient: (start, end) ->
#   {
#     background: start,
#     background:
#     
#   }  
#     
#     background: $start_color
#     background-image: -moz-linear-gradient(top, $start_color 0%, $end_color 100%) 
#     background-image: -webkit-gradient(linear, left top, left bottom, color-stop(0%,$start_color), color-stop(100%,$end_color))
# 
# 
# $.animateWrapBg = (color) ->
#   
  
# $.Color({ saturation: 0 })

class SpinnerView
  
  spinner: $("#spinner")
  bg: $("#wrap, body")
  
  
  spin: ->
    this.spinner.fadeIn()
    this.bg.animate({ backgroundColor: "#999999" }, 300)
     
    
    
  hide: ->
    this.spinner.fadeOut()
    this.bg.animate({ backgroundColor: "#DDDDDD" }, 300)