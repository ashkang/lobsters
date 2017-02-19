TextDirection = {}

TextDirection.RTL = 'rtl'
TextDirection.LTR = 'ltr'

TextDirection.Align = {}

TextDirection[TextDirection.RTL] = 'right'
TextDirection[TextDirection.LTR] = 'left'

TextDirection.detect = function(text) {
  var rtlChar = /[\u0590-\u083F]|[\u08A0-\u08FF]|[\uFB1D-\uFDFF]|[\uFE70-\uFEFF]/mg

  if (text.match(text))
    return TextDirection.RTL

  return TextDirection.LTR
}

TextDirection.direct = function(el) {
  var direction = TextDirection.detect(el.innerText)
  el.style.direction = direction
  el.style.textAlign = TextDirection.Align[direction]
}