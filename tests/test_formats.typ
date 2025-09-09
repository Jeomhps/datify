// To compile this file: typst compile --root .. tests/test_cldr_formats.typ
#import "/src/formats.typ": custom-date-format

#let date = datetime(year: 2025, month: 1, day: 5) // January 5, 2025

// Basic CLDR patterns
#assert(custom-date-format(date, pattern: "yyyy-MM-dd") == "2025-01-05")
#assert(custom-date-format(date, pattern: "dd/MM/yyyy") == "05/01/2025")
#assert(custom-date-format(date, pattern: "MM/dd/yyyy") == "01/05/2025")
#assert(custom-date-format(date, pattern: "d/M/yyyy") == "5/1/2025")
#assert(custom-date-format(date, pattern: "yyyy-M-d") == "2025-1-5")

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
