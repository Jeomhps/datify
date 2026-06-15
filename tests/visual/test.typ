// Visual regression: catches rendering/shaping regressions and gives
// `display-date` true end-to-end coverage (its content output is rendered here,
// not just its resolution). Limited to scripts covered by Typst's *embedded*
// fonts (Latin / Cyrillic / Greek) so the reference image is deterministic
// across environments (tytanic uses embedded fonts by default). The reference
// is generated with `tt update` and committed.
#import "/src/main.typ": custom-date-format, display-date

#let d = datetime(year: 2025, month: 1, day: 5)

= custom-date-format (full)

#custom-date-format(d, pattern: "full", lang: "en")

#custom-date-format(d, pattern: "full", lang: "fr")

#custom-date-format(d, pattern: "full", lang: "de")

#custom-date-format(d, pattern: "full", lang: "ru")

#custom-date-format(d, pattern: "full", lang: "el")

= display-date (document language)

#set text(lang: "fr")
#display-date(d)

#set text(lang: "en", region: "GB")
#display-date(d, pattern: "short")
