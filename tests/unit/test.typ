#import "/src/main.typ": *

// Smoke test: a representative spread of locales/scripts must format without
// panicking for every named pattern. The full locale set lives in datify-core;
// duplicating ~700 codes here was a maintenance liability, so this is a trimmed
// representative sample. Correctness for specific locales is asserted below.
#let _smoke_date = datetime(year: 2025, month: 9, day: 9)
#for lang in (
    "en", "en-GB", "fr", "fr-CA", "de", "es", "pt", "it", "nl",
    "ru", "uk", "el", "ar", "he", "fa", "hi", "th", "ja", "zh",
    "zh-Hant", "ko", "fi", "smn", "is", "tr", "vi", "zz",
  ) {
  for pat in ("full", "long", "medium", "short") {
    custom-date-format(_smoke_date, pattern: pat, lang: lang)
  }
}

// custom-date-format: Invalid date type (not a datetime)
#assert-panic(() => custom-date-format("not a datetime"))
#assert.eq(
  catch(() => custom-date-format("not a datetime")),
  "panicked with: \"Invalid date: must be a datetime object, got string\""
)
#assert-panic(() => custom-date-format(123))
#assert.eq(
  catch(() => custom-date-format(123)),
  "panicked with: \"Invalid date: must be a datetime object, got integer\""
)
#assert-panic(() => custom-date-format((1, 2, 3)))
#assert.eq(
  catch(() => custom-date-format((1, 2, 3))),
  "panicked with: \"Invalid date: must be a datetime object, got array\""
)
#assert-panic(() => custom-date-format(auto))
#assert.eq(
  catch(() => custom-date-format(auto)),
  "panicked with: \"Invalid date: must be a datetime object, got auto\""
)

// custom-date-format: Invalid pattern type (not a string)
#assert-panic(() => custom-date-format(datetime.today(), pattern: 123))
#assert.eq(
  catch(() => custom-date-format(datetime.today(), pattern: 123)),
  "panicked with: \"Invalid pattern: must be a string, got integer\""
)
#assert-panic(() => custom-date-format(datetime.today(), pattern: (1, 2)))
#assert.eq(
  catch(() => custom-date-format(datetime.today(), pattern: (1, 2))),
  "panicked with: \"Invalid pattern: must be a string, got array\""
)
#assert-panic(() => custom-date-format(datetime.today(), pattern: auto))
#assert.eq(
  catch(() => custom-date-format(datetime.today(), pattern: auto)),
  "panicked with: \"Invalid pattern: must be a string, got auto\""
)

// custom-date-format: Invalid language type (not a string)
#assert-panic(() => custom-date-format(datetime.today(), lang: 123))
#assert.eq(
  catch(() => custom-date-format(datetime.today(), lang: 123)),
  "panicked with: \"Invalid language: must be a string, got integer\""
)
#assert-panic(() => custom-date-format(datetime.today(), lang: (1, 2)))
#assert.eq(
  catch(() => custom-date-format(datetime.today(), lang: (1, 2))),
  "panicked with: \"Invalid language: must be a string, got array\""
)
#assert-panic(() => custom-date-format(datetime.today(), lang: auto))
#assert.eq(
  catch(() => custom-date-format(datetime.today(), lang: auto)),
  "panicked with: \"Invalid language: must be a string, got auto\""
)

// custom-date-format: Unknown language now falls back to the default locale
// (en) via datify-core's fallback chain instead of panicking.
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), lang: "zz"),
  custom-date-format(datetime(year: 2025, month: 9, day: 9), lang: "en")
)

// custom-date-format: Valid named patterns (should not panic)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "full", lang: "en"),
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "full", lang: "en")
)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "long", lang: "en"),
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "long", lang: "en")
)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "medium", lang: "en"),
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "medium", lang: "en")
)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "short", lang: "en"),
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "short", lang: "en")
)

// custom-date-format: Valid custom patterns (should not panic)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "yyyy-MM-dd", lang: "en"),
  "2025-09-09"
)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "EEEE, MMMM d, yyyy", lang: "en"),
  "Tuesday, September 9, 2025"
)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "dd'th day of 'MMMM", lang: "en"),
  "09th day of September"
)

// custom-date-format: Literal mode (quoted text)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "'year: 'yyyy", lang: "en"),
  "year: 2025"
)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "yyyy'/'MM'/'dd", lang: "en"),
  "2025/09/09"
)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "'it''s the' MMMM", lang: "en"),
  "it's the September"
)

// custom-date-format: Escaped quotes
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "'''quoted'''", lang: "en"),
  "'quoted'"
)

// custom-date-format: Non-Latin script (e.g., Russian)
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "full", lang: "ru"),
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "full", lang: "ru")
)

// custom-date-format: Edge case - empty pattern
#assert.eq(
  custom-date-format(datetime(year: 2025, month: 9, day: 9), pattern: "", lang: "en"),
  ""
)

#let date = datetime(year: 2025, month: 1, day: 5) // January 5, 2025

// Basic CLDR patterns
#assert(custom-date-format(date, pattern: "yyyy-MM-dd") == "2025-01-05")
#assert(custom-date-format(date, pattern: "dd/MM/yyyy") == "05/01/2025")
#assert(custom-date-format(date, pattern: "MM/dd/yyyy") == "01/05/2025")
#assert(custom-date-format(date, pattern: "d/M/yyyy") == "5/1/2025")
#assert(custom-date-format(date, pattern: "yyyy-M-d") == "2025-1-5")
#assert(custom-date-format(date, pattern: "short", lang: "de") == "05.01.25")

// Month and day names (English, default)
#assert(custom-date-format(date, pattern: "MMMM dd, yyyy") == "January 05, 2025")
#assert(custom-date-format(date, pattern: "MMM d, yyyy") == "Jan 5, 2025")
#assert(custom-date-format(date, pattern: "EEEE, MMMM dd, yyyy") == "Sunday, January 05, 2025")
#assert(custom-date-format(date, pattern: "EEE, MMM d, yyyy") == "Sun, Jan 5, 2025")

// French locale (lowercase day & month names, as per French CLDR)
#let fr_date = datetime(year: 2025, month: 8, day: 23)
#assert(custom-date-format(fr_date, pattern: "EEEE, dd MMMM yyyy", lang: "fr") == "samedi, 23 août 2025")
#assert(custom-date-format(fr_date, pattern: "EEE, dd MMM yyyy", lang: "fr") == "sam., 23 août 2025")
#assert(custom-date-format(fr_date, pattern: "dd/MM/yyyy", lang: "fr") == "23/08/2025")

// Spanish locale
#let es_date = datetime(year: 2025, month: 4, day: 7)
#assert(custom-date-format(es_date, pattern: "full", lang: "es") == "lunes, 7 de abril de 2025")
#assert(custom-date-format(es_date, pattern: "EEE, d MMM yyyy", lang: "es") == "lun, 7 abr 2025")

// Portuguese locale
#let pt_date = datetime(year: 2025, month: 10, day: 3)
#assert(custom-date-format(pt_date, pattern: "EEEE, dd 'de' MMMM 'de' yyyy", lang: "pt") == "sexta-feira, 03 de outubro de 2025")

// Stand-alone weekday (c). These locales' `full` pattern begins with `cccc`,
// which previously emitted the literal text "cccc". 2025-09-09 is a Tuesday.
#let c_date = datetime(year: 2025, month: 9, day: 9)
// Direct cccc -> stand-alone wide weekday
#assert(custom-date-format(c_date, pattern: "cccc", lang: "fi") == "tiistai")
// Finnish `full` = "cccc d. MMMM y"
#assert(custom-date-format(c_date, pattern: "full", lang: "fi") == "tiistai 9. syyskuuta 2025")
// Inari Sami `full` = "cccc, MMMM d. y"
#assert(custom-date-format(c_date, pattern: "full", lang: "smn") == "majebargâ, čohčâmáánu 9. 2025")

// Era field `G` is unsupported: datify-core ships no era data, so `G` passes
// through verbatim. Thai `full` = "EEEEที่ d MMMM G y" — weekday and month
// render correctly while the literal "G" remains. (Documented in the README.)
#assert(custom-date-format(c_date, pattern: "full", lang: "th") == "วันอังคารที่ 9 กันยายน G 2025")

// display-date: picks up the document language via `context text.lang`. The
// underlying resolution (what the wrapper does) is asserted here; the wrapper
// itself is placed below to confirm it compiles and returns content.
#let disp_date = datetime(year: 2025, month: 1, day: 5)
#set text(lang: "fr")
#context {
  assert.eq(
    custom-date-format(disp_date, pattern: "full", lang: text.lang),
    "dimanche 5 janvier 2025",
  )
}
#assert.eq(type(display-date(disp_date)), content) // wrapper returns content
#display-date(disp_date) // smoke: renders in the document language without error

// display-date also honors text.region: en vs en-GB differ for "short".
#set text(lang: "en", region: "GB")
#context {
  let code = text.lang + "-" + text.region
  assert.eq(code, "en-GB")
  assert.eq(custom-date-format(disp_date, pattern: "short", lang: code), "05/01/2025")
}
#set text(lang: "en", region: none)
#context assert.eq(custom-date-format(disp_date, pattern: "short", lang: text.lang), "1/5/25")

// Zero-padding edge case
#let pad_date = datetime(year: 2025, month: 2, day: 3)
#assert(custom-date-format(pad_date, pattern: "MM-dd") == "02-03")
#assert(custom-date-format(pad_date, pattern: "M-d") == "2-3")

// Using y instead of yyyy
#assert(custom-date-format(date, pattern: "M/d/y") == "1/5/2025")

// Named pattern (if supported by your code)
#assert(custom-date-format(date, pattern: "full", lang: "en") != "")

// Leap year check
#let leap_date = datetime(year: 2024, month: 2, day: 29)
#assert(custom-date-format(leap_date, pattern: "yyyy-MM-dd") == "2024-02-29")
