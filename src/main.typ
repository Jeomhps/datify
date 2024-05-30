#import "translations.typ": day-name, month-name
#import "formats.typ": custom-date-format

#let my-date-datetime = datetime(year: 2024, month: 8, day: 4)
#custom-date-format(my-date-datetime, "Month DD, YYYY")
