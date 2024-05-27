#let day-names =  toml("dayName.toml") 
#let month-names = toml("monthName.toml")

#let first-letter-to-upper(string) = (
  string.replace(regex("^\w"), m=>{upper(m.text)})
) 

#let day-name(weekday, lang: "en", upper: false) = (
  let weekday-to-str = str(weekday),
  if upper == true {
    return first-letter-to-upper(day-names.at(lang).at(weekday-to-str))
  } else {
    return day-names.at(lang).at(weekday-to-str)
  }
)

#let month-name(month, lang: "en", upper: false) = (
  let month-to-str = str(month),
  if upper == true {
    return first-letter-to-upper(month-names.at(lang).at(month-to-str))
  } else {
    return month-names.at(lang).at(month-to-str)
  }
)

#let written-date(date, lang: "en") = (
  return [#day-name(date.weekday, lang: lang) #date.day #month-name(date.month, lang: lang) #date.year]
)
