import toml
from pathlib import Path

# Paths
day_file = Path("../src/translations/day_name.toml")
month_file = Path("../src/translations/month_name.toml")
out_file = Path("../tests/test_generated_coverage.typ")

# Load TOML
day_trans = toml.load(day_file.open(encoding="utf-8"))
month_trans = toml.load(month_file.open(encoding="utf-8"))

lines = []
lines.append("// Generated Typst coverage tests for all translations and formats")
lines.append('#import "../src/translations.typ": day-name, month-name')
lines.append('#import "../src/formats.typ": custom-date-format\n')

# Days
for lang, days in day_trans.items():
    for i in range(1, 8):
        val = days.get(str(i))
        if val:
            lines.append(f'#assert(day-name({i}, "{lang}") == "{val}")')

lines.append("")
# Months
for lang, months in month_trans.items():
    for i in range(1, 13):
        val = months.get(str(i))
        if val:
            lines.append(f'#assert(month-name({i}, "{lang}") == "{val}")')

# Format tests
lines.append("\n// Format tests for custom-date-format")
lines.append("#let sample_date = datetime(year: 2024, month: 8, day: 5)")

for lang in day_trans:
    days = day_trans[lang]
    months = month_trans.get(lang, {})
    day_name = days.get("1", "")
    month_name = months.get("8", "")
    cap_day = day_name.capitalize() if day_name else ""
    cap_month = month_name.capitalize() if month_name else ""
    short_month = month_name[:3] if month_name else ""
    if day_name and month_name:
        lines.append(f'#assert(custom-date-format(sample_date, "YYYY-MM-DD", "{lang}") == "2024-08-05")')
        lines.append(f'#assert(custom-date-format(sample_date, "Day", "{lang}") == "{cap_day}")')
        lines.append(f'#assert(custom-date-format(sample_date, "Month", "{lang}") == "{cap_month}")')
        lines.append(f'#assert(custom-date-format(sample_date, "MMM", "{lang}") == "{short_month.capitalize()}")')
        lines.append(f'#assert(custom-date-format(sample_date, "DD Month YYYY", "{lang}") == "05 {cap_month} 2024")')

# Write output as UTF-8
with out_file.open("w", encoding="utf-8") as f:
    f.write("\n".join(lines) + "\n")

print(f"Generated Typst coverage tests at {out_file}")
