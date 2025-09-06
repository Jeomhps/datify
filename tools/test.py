from icu import Locale, DateFormat, SimpleDateFormat, Calendar, TimeZone
from datetime import datetime

# List of test cases: (date, pattern, locale)
test_cases = [
    # (year, month, day), pattern, locale
    ((2025, 1, 5), "yyyy-MM-dd", "en"),
    ((2025, 8, 23), "EEEE, dd MMMM yyyy", "fr"),
    ((2025, 8, 23), "EEE, dd MMM yyyy", "fr"),
    ((2024, 2, 29), "yyyy-MM-dd", "en"),
    ((2025, 4, 7), "EEEE, dd 'de' MMMM 'de' yyyy", "es"),
]

def icu_format(year, month, day, pattern, lang):
    # ICU months are 0-based: Jan=0, Feb=1, ...
    dt = datetime(year, month, day)
    locale = Locale(lang)
    tz = TimeZone.createTimeZone("UTC")
    cal = Calendar.createInstance(tz, locale)
    cal.set(year, month-1, day)
    sdf = SimpleDateFormat(pattern, locale)
    sdf.setCalendar(cal)
    return sdf.format(dt)

def typst_date_literal(year, month, day):
    return f"datetime(year: {year}, month: {month}, day: {day})"

lines = []
lines.append("// Generated Typst coverage tests for all translations and formats")
#lines.append('#import "@local/datify-core:1.0.0": day-name, month-name')
lines.append('#import "../src/formats.typ": custom-date-format\n')

for (y, m, d), pattern, lang in test_cases:
    expected = icu_format(y, m, d, pattern, lang)
    typst_date = typst_date_literal(y, m, d)
    # Escape double quotes in expected
    expected_escaped = expected.replace('"', '\\"')
    line = (
        f"#assert(custom-date-format({typst_date}, pattern: \"{pattern}\", lang: \"{lang}\") "
        f"== \"{expected_escaped}\")"
    )
    print(line)
    lines.append(line)


with open("../tests/generated_typst_asserts.typ", "w", encoding="utf-8") as f:
    f.write('\n'.join(lines) + '\n')
