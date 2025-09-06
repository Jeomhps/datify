#let first-letter-to-upper = (s) => {
  upper(s.first()) + s.clusters().slice(1).join()
}

// Take a number as an input and a length,
// if number is not as big as length, return the number
// with 0 padding in front, like 9 with length 2
// will return 09
#let pad = (number, length, pad_char: "0") => {
  let str_num = str(number)
  let padding = ""
  while str_num.len() + padding.len() < length {
    padding += pad_char
  }
  return padding + str_num
}

// Take a string and a length, and return the first `length` grapheme clusters
// (what a human sees as characters). If the string is shorter than `length`,
// returns the whole string. This is Unicode-safe and works for non-Latin scripts.
// Example: safe-slice("August", 3) -> "Aug"
// Example: safe-slice("אוגוסט", 3) -> "אוגוס"
#let safe-slice = (s, length) => {
  let clusters = s.clusters()
  let n = if length > clusters.len() { clusters.len() } else { length }
  clusters.slice(0, n).join()
}
