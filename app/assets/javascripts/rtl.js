TextDirection = {}

TextDirection.RTL = 'rtl'
TextDirection.LTR = 'ltr'

TextDirection.Align = {}

TextDirection.Align[TextDirection.RTL] = 'right'
TextDirection.Align[TextDirection.LTR] = 'left'

TextDirection.rtlCharacters = /[\u0590-\u083F]|[\u08A0-\u08FF]|[\uFB1D-\uFDFF]|[\uFE70-\uFEFF]/mg

TextDirection.detect = function(text) {
  if (text.match(TextDirection.rtlCharacters))
    return TextDirection.RTL

  return TextDirection.LTR
}

TextDirection.direct = function(el) {
  var direction = TextDirection.detect(el.innerText)
  el.style.direction = direction
  el.style.textAlign = TextDirection.Align[direction]
}