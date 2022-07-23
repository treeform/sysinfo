import osproc, strutils

proc tryParseInt*(s: string): int =
  try:
    parseInt(s)
  except:
    0
