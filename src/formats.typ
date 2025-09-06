#import "@local/datify-core:1.0.0": *
#import "utils.typ": *

#let custom-date-format = (
  date,
  pattern: "full",
  lang: "en",
) => {
  // Resolve named pattern if needed
  if pattern == "full" or pattern == "long" or pattern == "medium" or pattern == "short" {
    pattern = get-date-pattern(pattern, lang: lang)
  }

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

  // Split pattern on whitespace to get tokens
  let tokens = pattern.split(" ")

  // Build result as a string
  // let result = ""
  // for i in range(tokens.len()) {
  //   let token = tokens.at(i)
  //   let found = false
  //   // Replace each symbol in token, longest first
  //   for key in ("EEEE", "MMMM", "yyyy", "EEE", "MMM", "MM", "dd", "M", "d", "y") {
  //     if not found and token.contains(key) {
  //       token = token.replace(key, symbol-values.at(key))
  //       found = true
  //     }
  //   }
  //   // Add space between tokens, but not after the last one
  //   if i > 0 {
  //     result += " "
  //   }
  //   result += token
  // }
  //
  // let result = ""
  //  for i in range(tokens.len()) {
  //    let token = tokens.at(i)
  //    if tokens.len() == 1 {
  //      // Single-token: replace all symbols in order, no early stop
  //      for key in ("EEEE", "MMMM", "yyyy", "EEE", "MMM", "MM", "dd", "M", "d", "y") {
  //        if token.contains(key) {
  //          token = token.replace(key, symbol-values.at(key))
  //        }
  //      }
  //    } else {
  //      let found = false
  //      // Multi-token: stop after the first match
  //      for key in ("EEEE", "MMMM", "yyyy", "EEE", "MMM", "MM", "dd", "M", "d", "y") {
  //        if not found and token.contains(key) {
  //          token = token.replace(key, symbol-values.at(key))
  //          found = true
  //        }
  //      }
  //    }
  //    // Add space between tokens, but not after the last one
  //    if i > 0 {
  //      result += " "
  //    }
  //    result += token
  //  }

   let chunks = ()
   let buffer = ""
   let in_literal = false
   for c in pattern.clusters() {
     if c == "'" {
       if buffer != "" {
         chunks.push((in_literal, buffer))
         buffer = ""
       }
       in_literal = not in_literal
     } else {
       buffer += c
     }
   }
   if buffer != "" {
     chunks.push((in_literal, buffer))
   }

   // Now process chunks
   let result = ""
   for (is_lit, chunk) in chunks {
     if is_lit {
       // Literal: append as-is (remove quotes)
       result += chunk
     } else {
       // Non-literal: do symbol replacement
       // Optionally: split on whitespace and use your multi-token logic, or just do a "global" replace
       // Here's a "global" replace, longest key first:
       for key in ("EEEE", "MMMM", "yyyy", "EEE", "MMM", "MM", "dd", "M", "d", "y") {
         chunk = chunk.replace(key, symbol-values.at(key))
       }
       result += chunk
     }
   }
   return result
 }

  return result
}
