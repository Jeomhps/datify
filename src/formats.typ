#import "@preview/datify-core:1.0.0": *
#import "utils.typ": *

#let custom-date-format = (
  date,
  pattern: "full",
  lang: "en",
) => {
  // Validate date type (must be a datetime)
  if type(date) != datetime {
    panic("Invalid date: must be a datetime object, got " + str(type(date)))
  }

  // Symbol lookup
  let symbol-values = (
    "EEEE": get-day-name(date.weekday(), lang: lang, usage: "format", width: "wide"),
    "EEE": get-day-name(date.weekday(), lang: lang, usage: "format", width: "abbreviated"),
    "MMMM": get-month-name(date.month(), lang: lang, usage: "format", width: "wide"),
    "MMM": get-month-name(date.month(), lang: lang, usage: "format", width: "abbreviated"),
    "MM": pad(date.month(), 2),
    "M": str(date.month()),
    "dd": pad(date.day(), 2),
    "d": str(date.day()),
    "yyyy": str(date.year()),
    "y": str(date.year()),
  )

  // Validate pattern
  if type(pattern) != str {
    panic("Invalid pattern: must be a string, got " + str(type(pattern)))
  }

  // Validate lang
  if type(lang) != str {
    panic("Invalid language: must be a string, got " + str(type(lang)))
  }

  let tokens = ("EEEE", "MMMM", "yyyy", "EEE", "MMM", "MM", "dd", "M", "d", "y")

  // If named pattern, resolve it
  if pattern == "full" or pattern == "long" or pattern == "medium" or pattern == "short" {
    pattern = get-date-pattern(pattern, lang: lang)
  }

  // Manual parsing for literals and tokenizing symbols
  let result = ""
  let in_literal = false
  let i = 0
  while i < pattern.clusters().len() {
    let c = safe-slice(pattern, i, i+1)
    if c == "'" {
      // Handle escaped quote
      if i+1 < pattern.clusters().len() and safe-slice(pattern, i+1, i+2) == "'" {
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
      if i + key.len() <= pattern.clusters().len() and safe-slice(pattern, i, i + key.len()) == key {
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
