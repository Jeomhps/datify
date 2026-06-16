// Unit tests for `display-date` (the content-returning, document-locale wrapper).
//
// display-date returns content (it wraps a `context`), so its rendered value
// can't be string-compared directly. We assert (a) the contract (it returns
// content and compiles), and (b) the exact resolution it performs — combining
// text.lang/text.region and calling custom-date-format — which is what actually
// determines its output.
#import "/src/main.typ": custom-date-format, display-date

#let d = datetime(year: 2025, month: 1, day: 5) // Sunday, 5 January 2025

// --- Contract: returns content, and placing it compiles ---
#assert.eq(type(display-date(d)), content)
#assert.eq(type(display-date(d, pattern: "short")), content)
#display-date(d) // smoke: renders without error

// --- Default: with no `#set text`, text.lang is "en" ---
#context {
  assert.eq(text.lang, "en")
  assert.eq(custom-date-format(d, lang: text.lang), custom-date-format(d, lang: "en"))
}

// --- Uses the document language ---
#set text(lang: "fr")
#context {
  assert.eq(custom-date-format(d, pattern: "full", lang: text.lang), "dimanche 5 janvier 2025")
  // custom patterns pass through, still in the document language
  assert.eq(custom-date-format(d, pattern: "EEEE d MMMM y", lang: text.lang), "dimanche 5 janvier 2025")
}
#display-date(d) // smoke under fr

// --- Honors text.region: en vs en-GB differ for "short" ---
#set text(lang: "en", region: "GB")
#context {
  let code = text.lang + if text.region != none { "-" + text.region } else { "" }
  assert.eq(code, "en-GB")
  assert.eq(custom-date-format(d, pattern: "short", lang: code), "05/01/2025")
}

// --- Region undefined -> base language only (the `text.region == none` path) ---
#set text(lang: "en", region: none)
#context {
  assert.eq(text.region, none)
  assert.eq(custom-date-format(d, pattern: "short", lang: text.lang), "1/5/25")
}

// --- community flag is threaded through display-date ---
#assert.eq(type(display-date(d, community: true)), content)
#let mon = datetime(year: 2025, month: 1, day: 6) // Monday (narrow differs under overlay)
#set text(lang: "pt", region: "BR")
#context {
  assert.eq(text.lang + "-" + text.region, "pt-BR")
  assert.eq(custom-date-format(mon, pattern: "ccccc", lang: "pt-BR"), "S")               // off -> CLDR
  assert.eq(custom-date-format(mon, pattern: "ccccc", lang: "pt-BR", community: true), "2ª") // on -> overlay
}
#display-date(mon, community: true) // smoke
