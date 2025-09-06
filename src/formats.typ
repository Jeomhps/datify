#import "@local/datify-core:1.0.0": *
#import "utils.typ": *

#let custom-date-format = (
  date,
  pattern: "full",
  lang: "en",
) => {
  // Symbol lookup
  let symbol-values = (
    "EEEE": get-day-name(date.weekday(), lang: lang, type: "format", width: "wide"),
    "EEE": get-day-name(date.weekday(), lang: lang, type: "format", width: "abbreviated"),
    "MMMM": get-month-name(date.month(), lang: lang, type: "format", width: "wide"),
    "MMM": get-month-name(date.month(), lang: lang, type: "format", width: "abbreviated"),
    "MM": pad(date.month(), 2),
    "M": str(date.month()),
    "dd": pad(date.day(), 2),
    "d": str(date.day()),
    "yyyy": str(date.year()),
    "y": str(date.year()),
  )
  let tokens = ("EEEE", "MMMM", "yyyy", "EEE", "MMM", "MM", "dd", "M", "d", "y")

  // If named pattern, resolve it
  if pattern == "full" or pattern == "long" or pattern == "medium" or pattern == "short" {
    pattern = get-date-pattern(pattern, lang: lang)
  }

  // Manual parsing for literals and tokenizing symbols
  let result = ""
  let in_literal = false
  let i = 0
  while i < pattern.len() {
    let c = pattern.slice(i, i+1)
    if c == "'" {
      // Handle escaped quote
      if i+1 < pattern.len() and pattern.slice(i+1, i+2) == "'" {
        result += "'"
        i += 2
        continue
      }
      in_literal = not in_literal
      i += 1
      continue
    }
    if in_literal {
      result += c
      i += 1
      continue
    }
    // Try to match any symbol at this position, longest first
    let matched = false
    for key in tokens {
      if i + key.len() <= pattern.len() and pattern.slice(i, i + key.len()) == key {
        result += symbol-values.at(key)
        i += key.len()
        matched = true
        break
      }
    }
    if not matched {
      result += c
      i += 1
    }
  }
  return result
}
