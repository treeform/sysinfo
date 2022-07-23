import osproc, parseutils

proc tryParseInt*(s: string): int =
  try:
    var number: int = 0
    discard parseInt(s, number)
    return number
  except:
    discard

proc tryParseFloat*(s: string): float =
  try:
    var number: float = 0
    discard parseFloat(s, number)
    return number
  except:
    discard
