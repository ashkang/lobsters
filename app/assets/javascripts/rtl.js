TextDirection = {}

TextDirection.RTL = 'rtl'
TextDirection.LTR = 'ltr'


TextDirection.detect = function(text) {
  var rtlChar = /[\u0590-\u083F]|[\u08A0-\u08FF]|[\uFB1D-\uFDFF]|[\uFE70-\uFEFF]/mg

  if (text.match(text))
    return TextDirection.RTL

  return TextDirection.LTR
}

TextDirection.direct = function(el) {
  el.style.direction = TextDirection.detect(el.innerText)
}