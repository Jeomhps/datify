#import "@preview/datify-core:2.0.0": *
#import "utils.typ": *

// Resolve a single CLDR field run (a maximal run of one letter) to its value.
// `letter` is the field symbol, `n` the run length. Returns `none` for symbols
// we do not handle (e.g. era `G`), so the caller passes the run through verbatim.
//
// Only the symbols that occur in the CLDR patterns datify-core ships are mapped,
// plus their obvious siblings. Resolution is lazy: get-* is only called for the
// runs that actually appear in the pattern.
#let _symbol-value = (letter, n, date, lang) => {
  if letter == "y" {
    // yy -> last two digits; any other length -> full year
    if n == 2 { return str(date.display("[year repr:last_two]")) }
    return str(date.year())
  }
  if letter == "M" {
    if n == 1 { return str(date.month()) }
    if n == 2 { return pad(date.month(), 2) }
    if n == 3 { return get-month-name(date.month(), lang: lang, usage: "format", width: "abbreviated") }
    if n == 4 { return get-month-name(date.month(), lang: lang, usage: "format", width: "wide") }
    return get-month-name(date.month(), lang: lang, usage: "format", width: "narrow")
  }
  if letter == "L" {
    // stand-alone month
    if n == 1 { return str(date.month()) }
    if n == 2 { return pad(date.month(), 2) }
    if n == 3 { return get-month-name(date.month(), lang: lang, usage: "stand-alone", width: "abbreviated") }
    if n == 4 { return get-month-name(date.month(), lang: lang, usage: "stand-alone", width: "wide") }
    return get-month-name(date.month(), lang: lang, usage: "stand-alone", width: "narrow")
  }
  if letter == "d" {
    if n == 1 { return str(date.day()) }
    return pad(date.day(), 2)
  }
  if letter == "E" {
    // format weekday
    if n <= 3 { return get-day-name(date.weekday(), lang: lang, usage: "format", width: "abbreviated") }
    if n == 4 { return get-day-name(date.weekday(), lang: lang, usage: "format", width: "wide") }
    return get-day-name(date.weekday(), lang: lang, usage: "format", width: "narrow")
  }
  if letter == "c" {
    // stand-alone weekday
    if n <= 3 { return get-day-name(date.weekday(), lang: lang, usage: "stand-alone", width: "abbreviated") }
    if n == 4 { return get-day-name(date.weekday(), lang: lang, usage: "stand-alone", width: "wide") }
    return get-day-name(date.weekday(), lang: lang, usage: "stand-alone", width: "narrow")
  }
  // Unhandled field symbol (e.g. era `G`): pass through verbatim.
  return none
}

#let custom-date-format = (
  date,
  pattern: "full",
  lang: "en",
) => {
  // Validate date type (must be a datetime)
  if type(date) != datetime {
    panic("Invalid date: must be a datetime object, got " + str(type(date)))
  }

  // Validate pattern
  if type(pattern) != str {
    panic("Invalid pattern: must be a string, got " + str(type(pattern)))
  }

  // Validate lang
  if type(lang) != str {
    panic("Invalid language: must be a string, got " + str(type(lang)))
  }

  // If named pattern, resolve it
  if (
    pattern == "full"
      or pattern == "long"
      or pattern == "medium"
      or pattern == "short"
  ) {
    pattern = get-date-pattern(pattern, lang: lang)
  }

  // Parse the pattern string into the final result.
  // Scan a maximal run of the same letter, then map (letter, run-length) to a
  // value. Keep the '-literal / ''-escape handling exactly as before.
  let result = ""
  let in_literal_mode = false
  let current_position = 0
  let pattern_length = pattern.clusters().len()

  while (current_position < pattern_length) {
    let current_char = safe-slice(
      pattern,
      current_position,
      current_position + 1,
    )

    // Handle literal mode (quoted text)
    if (current_char == "'") {
      // Check for escaped quote (two single quotes in a row)
      if (
        current_position + 1 < pattern_length
          and safe-slice(pattern, current_position + 1, current_position + 2)
            == "'"
      ) {
        result += "'"
        current_position += 2
        continue
      }
      // Toggle literal mode
      in_literal_mode = not in_literal_mode
      current_position += 1
      continue
    }

    // In literal mode, append characters as-is
    if (in_literal_mode) {
      result += current_char
      current_position += 1
      continue
    }

    // Read the maximal run of the current character.
    let run_length = 1
    while (
      current_position + run_length < pattern_length
        and safe-slice(
          pattern,
          current_position + run_length,
          current_position + run_length + 1,
        )
          == current_char
    ) {
      run_length += 1
    }

    let value = _symbol-value(current_char, run_length, date, lang)
    if (value == none) {
      // Unhandled symbol or ordinary literal character(s): pass through.
      result += safe-slice(
        pattern,
        current_position,
        current_position + run_length,
      )
    } else {
      result += value
    }
    current_position += run_length
  }

  return result
}
