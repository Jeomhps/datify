// Unit tests for `custom-date-format` (the string-returning formatter).
#import "/src/main.typ": custom-date-format

#let d = datetime(year: 2025, month: 1, day: 5) // Sunday, 5 January 2025
#let sept = datetime(year: 2025, month: 9, day: 9) // Tuesday, 9 September 2025

// --- Smoke: a representative spread of locales/scripts must format every named
// pattern without panicking. (The full locale set lives in datify-core.) ---
#for lang in (
    "en", "en-GB", "fr", "fr-CA", "de", "es", "pt", "it", "nl", "ru", "uk",
    "el", "ar", "he", "fa", "hi", "th", "ja", "zh", "zh-Hant", "ko", "fi",
    "smn", "is", "tr", "vi", "zz",
  ) {
  for pat in ("full", "long", "medium", "short") {
    custom-date-format(sept, pattern: pat, lang: lang)
  }
}

// --- Input validation: `date` must be a datetime ---
#assert-panic(() => custom-date-format("not a datetime"))
#assert.eq(catch(() => custom-date-format("not a datetime")), "panicked with: \"Invalid date: must be a datetime object, got string\"")
#assert-panic(() => custom-date-format(123))
#assert.eq(catch(() => custom-date-format(123)), "panicked with: \"Invalid date: must be a datetime object, got integer\"")
#assert-panic(() => custom-date-format((1, 2, 3)))
#assert.eq(catch(() => custom-date-format((1, 2, 3))), "panicked with: \"Invalid date: must be a datetime object, got array\"")
#assert-panic(() => custom-date-format(auto))
#assert.eq(catch(() => custom-date-format(auto)), "panicked with: \"Invalid date: must be a datetime object, got auto\"")

// --- Input validation: `pattern` must be a string ---
#assert-panic(() => custom-date-format(d, pattern: 123))
#assert.eq(catch(() => custom-date-format(d, pattern: 123)), "panicked with: \"Invalid pattern: must be a string, got integer\"")
#assert-panic(() => custom-date-format(d, pattern: (1, 2)))
#assert.eq(catch(() => custom-date-format(d, pattern: (1, 2))), "panicked with: \"Invalid pattern: must be a string, got array\"")
#assert-panic(() => custom-date-format(d, pattern: auto))
#assert.eq(catch(() => custom-date-format(d, pattern: auto)), "panicked with: \"Invalid pattern: must be a string, got auto\"")

// --- Input validation: `lang` must be a string ---
#assert-panic(() => custom-date-format(d, lang: 123))
#assert.eq(catch(() => custom-date-format(d, lang: 123)), "panicked with: \"Invalid language: must be a string, got integer\"")
#assert-panic(() => custom-date-format(d, lang: (1, 2)))
#assert.eq(catch(() => custom-date-format(d, lang: (1, 2)), ), "panicked with: \"Invalid language: must be a string, got array\"")
#assert-panic(() => custom-date-format(d, lang: auto))
#assert.eq(catch(() => custom-date-format(d, lang: auto)), "panicked with: \"Invalid language: must be a string, got auto\"")

// --- Unknown language falls back to the default (en) instead of panicking ---
#assert.eq(custom-date-format(d, lang: "zz"), custom-date-format(d, lang: "en"))

// --- Named patterns ---
#assert.eq(custom-date-format(d, pattern: "full", lang: "en"), "Sunday, January 5, 2025")
#assert.eq(custom-date-format(d, pattern: "long", lang: "en"), "January 5, 2025")
#assert.eq(custom-date-format(d, pattern: "medium", lang: "en"), "Jan 5, 2025")
#assert.eq(custom-date-format(d, pattern: "short", lang: "en"), "1/5/25")
#assert.eq(custom-date-format(d, pattern: "short", lang: "de"), "05.01.25")

// --- Numeric / basic patterns ---
#assert.eq(custom-date-format(d, pattern: "yyyy-MM-dd"), "2025-01-05")
#assert.eq(custom-date-format(d, pattern: "dd/MM/yyyy"), "05/01/2025")
#assert.eq(custom-date-format(d, pattern: "MM/dd/yyyy"), "01/05/2025")
#assert.eq(custom-date-format(d, pattern: "d/M/yyyy"), "5/1/2025")
#assert.eq(custom-date-format(d, pattern: "yyyy-M-d"), "2025-1-5")
#assert.eq(custom-date-format(d, pattern: "M/d/y"), "1/5/2025")

// --- Names in custom patterns (English) ---
#assert.eq(custom-date-format(d, pattern: "MMMM dd, yyyy"), "January 05, 2025")
#assert.eq(custom-date-format(d, pattern: "MMM d, yyyy"), "Jan 5, 2025")
#assert.eq(custom-date-format(d, pattern: "EEEE, MMMM dd, yyyy"), "Sunday, January 05, 2025")
#assert.eq(custom-date-format(d, pattern: "EEE, MMM d, yyyy"), "Sun, Jan 5, 2025")

// --- Run-length tokenizer: new tokens & widths ---
#assert.eq(custom-date-format(d, pattern: "E", lang: "en"), "Sun") // single E -> abbreviated weekday
#assert.eq(custom-date-format(d, pattern: "EEEEE", lang: "en"), "S") // narrow weekday
#assert.eq(custom-date-format(d, pattern: "MMMMM", lang: "en"), "J") // narrow month
#assert.eq(custom-date-format(d, pattern: "LLLL", lang: "en"), "January") // stand-alone month
#assert.eq(custom-date-format(d, pattern: "LLL", lang: "en"), "Jan")
#assert.eq(custom-date-format(d, pattern: "ccc", lang: "en"), "Sun") // stand-alone weekday
// stand-alone (L) and format (M) months differ in Russian
#assert.eq(custom-date-format(d, pattern: "LLLL", lang: "ru"), "январь") // nominative
#assert.eq(custom-date-format(d, pattern: "MMMM", lang: "ru"), "января") // genitive
// Over-length / malformed runs collapse to a single field (not concatenated):
// the run-length scanner reads the whole run as one token.
#assert.eq(custom-date-format(d, pattern: "ddd", lang: "en"), "05") // not "055"
#assert.eq(custom-date-format(d, pattern: "dddd", lang: "en"), "05")
#assert.eq(custom-date-format(d, pattern: "yyy", lang: "en"), "2025") // not "252025"

// --- Locale day/month names (fr, es, pt) ---
#let fr_date = datetime(year: 2025, month: 8, day: 23)
#assert.eq(custom-date-format(fr_date, pattern: "EEEE, dd MMMM yyyy", lang: "fr"), "samedi, 23 août 2025")
#assert.eq(custom-date-format(fr_date, pattern: "EEE, dd MMM yyyy", lang: "fr"), "sam., 23 août 2025")
#assert.eq(custom-date-format(fr_date, pattern: "dd/MM/yyyy", lang: "fr"), "23/08/2025")
#let es_date = datetime(year: 2025, month: 4, day: 7)
#assert.eq(custom-date-format(es_date, pattern: "full", lang: "es"), "lunes, 7 de abril de 2025")
#assert.eq(custom-date-format(es_date, pattern: "EEE, d MMM yyyy", lang: "es"), "lun, 7 abr 2025")
#let pt_date = datetime(year: 2025, month: 10, day: 3)
#assert.eq(custom-date-format(pt_date, pattern: "EEEE, dd 'de' MMMM 'de' yyyy", lang: "pt"), "sexta-feira, 03 de outubro de 2025")

// --- Stand-alone weekday `cccc` inside named patterns (fi, smn) ---
#assert.eq(custom-date-format(sept, pattern: "cccc", lang: "fi"), "tiistai")
#assert.eq(custom-date-format(sept, pattern: "full", lang: "fi"), "tiistai 9. syyskuuta 2025")
#assert.eq(custom-date-format(sept, pattern: "full", lang: "smn"), "majebargâ, čohčâmáánu 9. 2025")

// --- Era field `G` is unsupported -> passes through verbatim (Thai) ---
#assert.eq(custom-date-format(sept, pattern: "full", lang: "th"), "วันอังคารที่ 9 กันยายน G 2025")

// --- Literals & escaped quotes ---
#assert.eq(custom-date-format(d, pattern: "'year: 'yyyy", lang: "en"), "year: 2025")
#assert.eq(custom-date-format(d, pattern: "yyyy'/'MM'/'dd", lang: "en"), "2025/01/05")
#assert.eq(custom-date-format(d, pattern: "'it''s the' MMMM", lang: "en"), "it's the January")
#assert.eq(custom-date-format(d, pattern: "'''quoted'''", lang: "en"), "'quoted'")
#assert.eq(custom-date-format(d, pattern: "dd'th day of 'MMMM", lang: "en"), "05th day of January")

// --- Edge cases ---
#assert.eq(custom-date-format(d, pattern: "", lang: "en"), "") // empty pattern
#assert(custom-date-format(d, pattern: "full", lang: "ru") != "") // non-Latin renders
#let pad_date = datetime(year: 2025, month: 2, day: 3)
#assert.eq(custom-date-format(pad_date, pattern: "MM-dd"), "02-03")
#assert.eq(custom-date-format(pad_date, pattern: "M-d"), "2-3")
#let leap_date = datetime(year: 2024, month: 2, day: 29)
#assert.eq(custom-date-format(leap_date, pattern: "yyyy-MM-dd"), "2024-02-29")
