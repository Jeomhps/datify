// To compile this file : typst compile --root .. .\test_formats.typ

#import "../src/formats.typ": custom-date-format

#let date = datetime(year: 2024, month: 8, day: 29)

#assert(custom-date-format(date, "YYYY-MM-DD") == "2024-08-29")
#assert(custom-date-format(date, "MM/DD/YYYY") == "08/29/2024")
#assert(custom-date-format(date, "Month DD, YYYY") == "August 29, 2024")
#assert(custom-date-format(date, "month DD, YYYY") == "august 29, 2024")
#assert(custom-date-format(date, "month DDth, YYYY") == "august 29th, 2024")
#assert(custom-date-format(date, "YYYY-mM-dD") == "2024-8-29")

#let shortdate = datetime(year: 2025, month: 4, day: 4)

#assert(custom-date-format(shortdate, "dD. MM. YYYY") == "4. 04. 2025")
#assert(custom-date-format(shortdate, "DD. mM. YYYY") == "04. 4. 2025")
#assert(custom-date-format(shortdate, "dD. mM. YYYY") == "4. 4. 2025")

#let french_date = datetime(year: 2024, month: 5, day: 23)
#assert(custom-date-format(french_date, "Day, DD Month YYYY", "fr") == "Jeudi, 23 Mai 2024")

#let french_date = datetime(year: 2024, month: 8, day: 23)
#assert(custom-date-format(french_date, "Day, DD mmm YYYY", "fr") == "Vendredi, 23 aoû 2024")

#let french_date = datetime(year: 2024, month: 8, day: 23)
#assert(custom-date-format(french_date, "Day, DD MMM YYYY", "fr") == "Vendredi, 23 Aoû 2024")

#let spanish_date = datetime(year: 2023, month: 2, day: 23)
#assert(custom-date-format(spanish_date, "day, DD de month de YYYY", "es") == "jueves, 23 de febrero de 2023")

#let spanish_date = datetime(year: 2024, month: 8, day: 9)
#assert(custom-date-format(spanish_date, "day, DD de month de YYYY", "es") == "viernes, 09 de agosto de 2024")

#let portuguese_date = datetime(year: 2024, month: 10, day: 23)
#assert(custom-date-format(portuguese_date, "day, DD de month de YYYY", "pt") == "quarta-feira, 23 de outubro de 2024")

#let portuguese_date = datetime(year: 2024, month: 7, day: 7)
#assert(custom-date-format(portuguese_date, "day, DD de month de YYYY", "pt") == "domingo, 07 de julho de 2024")

#let hebrew_date = datetime(year: 2024, month: 11, day: 23)
#assert(custom-date-format(hebrew_date, "day, ה-DD לmonth, YYYY", "he") == "שבת, ה-23 לנובמבר, 2024")

#let hebrew_date = datetime(year: 2024, month: 12, day: 7)
#assert(custom-date-format(hebrew_date, "day, ה-DD לmonth, YYYY", "he") == "שבת, ה-07 לדצמבר, 2024")

#let catalan_date = datetime(year: 2024, month: 8, day: 9)
#assert(custom-date-format(catalan_date, "divendres, DD d'month de YYYY", "ca") == "divendres, 09 d'agost de 2024")

#let catalan_date = datetime(year: 2025, month: 1, day: 9)
#assert(custom-date-format(catalan_date, "divendres, DD de month de YYYY", "ca") == "divendres, 09 de gener de 2025")

#let german_austrian_date = datetime(year: 2025, month: 1, day: 9)
#assert(custom-date-format(german_austrian_date, "Month DD, YYYY", "de-AT") == "Jänner 09, 2025")

// Russian
#let russian_date = datetime(year: 2024, month: 11, day: 23)
#assert(custom-date-format(russian_date, "day, DD month YYYY", "ru") == "суббота, 23 ноября 2024")

#let russian_date = datetime(year: 2024, month: 12, day: 7)
#assert(custom-date-format(russian_date, "day, DD month YYYY", "ru") == "суббота, 07 декабря 2024")

// Dutch
#let dutch_date = datetime(year: 2024, month: 11, day: 23)
#assert(custom-date-format(dutch_date, "day, DD month YYYY", "nl") == "zaterdag, 23 november 2024")

#let dutch_date = datetime(year: 2024, month: 12, day: 7)
#assert(custom-date-format(dutch_date, "day, DD month YYYY", "nl") == "zaterdag, 07 december 2024")

// Greek
#let greek_date = datetime(year: 2024, month: 3, day: 4)
#assert(custom-date-format(greek_date, "day, DD month YYYY", "el") == "δευτέρα, 04 μάρτιος 2024")

#let greek_date = datetime(year: 2024, month: 8, day: 15)
#assert(custom-date-format(greek_date, "day, DD month YYYY", "el") == "πέμπτη, 15 αύγουστος 2024")

// Italian [it]
#let italian_date = datetime(year: 2017, month: 3, day: 14)
#assert(custom-date-format(italian_date, "day, DD month YYYY", "it") == "martedì, 14 marzo 2017")

#let italian_date = datetime(year: 2025, month: 6, day: 15)
#assert(custom-date-format(italian_date, "Day DD month YYYY", "it") == "Domenica 15 giugno 2025")