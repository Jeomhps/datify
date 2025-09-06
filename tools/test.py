import requests
import toml
from icu import Locale, SimpleDateFormat, DateFormat, Calendar, TimeZone
from datetime import datetime

# Download TOML file from GitHub
TOML_URL = "https://raw.githubusercontent.com/Jeomhps/datify-core/main/src/translations/cldr-dates.toml"
response = requests.get(TOML_URL)
response.raise_for_status()
toml_text = response.text

# Parse TOML (now keys are locale codes)
toml_data = toml.loads(toml_text)

# Extract all locale codes that have a 'patterns' key
locales = []
for locale_key, value in toml_data.items():
    if isinstance(value, dict) and "patterns" in value:
        locales.append(locale_key)

print("Locales found:", locales)  # You should see aa, af, af-NA, etc.

# The rest of your code is unchanged...
named_patterns = ["full", "long", "medium", "short"]
custom_patterns = [
    "yyyy-MM-dd",
    "EEEE, dd MMMM yyyy",
    "EEE, dd MMM yyyy",
]
all_patterns = named_patterns + custom_patterns

test_dates = [
    (2025, 1, 5),
    (2024, 2, 29),
    (2025, 8, 23),
]

def icu_format(year, month, day, pattern, lang):
    dt = datetime(year, month, day)
    locale = Locale(lang)
    tz = TimeZone.createTimeZone("UTC")
    cal = Calendar.createInstance(tz, locale)
    cal.set(year, month-1, day)
    if pattern in ["full", "long", "medium", "short"]:
        sdf = DateFormat.createDateInstance(
            getattr(DateFormat, pattern.upper()), locale)
    else:
        sdf = SimpleDateFormat(pattern, locale)
    sdf.setCalendar(cal)
    return sdf.format(dt)

def typst_date_literal(year, month, day):
    return f"datetime(year: {year}, month: {month}, day: {day})"

lines = []
lines.append("// Generated Typst coverage tests for all translations and formats")
lines.append('#import "../src/formats.typ": custom-date-format\n')

for lang in locales:
    for (y, m, d) in test_dates:
        for pattern in all_patterns:
            try:
                expected = icu_format(y, m, d, pattern, lang)
            except Exception as e:
                # ICU throws for unsupported or weird locales/patterns
                continue
            typst_date = typst_date_literal(y, m, d)
            expected_escaped = expected.replace('"', '\\"')
            line = (
                f"#assert(custom-date-format({typst_date}, pattern: \"{pattern}\", lang: \"{lang}\") "
                f"== \"{expected_escaped}\")"
            )
            lines.append(line)

with open("../tests/generated_typst_asserts.typ", "w", encoding="utf-8") as f:
    f.write('\n'.join(lines) + '\n')
