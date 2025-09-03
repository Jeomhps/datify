import random
from datetime import datetime, timedelta
from babel.dates import format_date
import os

# Map Typst format string to Babel format string and a "postprocess" function if needed
FORMAT_MAP = [
    ("YYYY-MM-DD", "yyyy-MM-dd", None),
    ("MM/DD/YYYY", "MM/dd/yyyy", None),
    ("Month DD, YYYY", "MMMM dd, yyyy", "capitalize_month"),
    ("month DD, YYYY", "MMMM dd, yyyy", "lower_month"),
    ("YYYY-mM-dD", "yyyy-M-d", None),
    ("Day, DD Month YYYY", "EEEE, dd MMMM yyyy", "capitalize_day_month"),
    ("day, DD Month YYYY", "EEEE, dd MMMM yyyy", "lower_day_month"),
    ("Day, DD mmm YYYY", "EEEE, dd MMM yyyy", "mmm_lower"),
    ("Day, DD MMM YYYY", "EEEE, dd MMM yyyy", "MMM_cap"),
    ("day, DD de month de YYYY", "EEEE, dd 'de' MMMM 'de' yyyy", "lower_day_month"),
    ("divendres, DD d'month de YYYY", "EEEE, dd 'd' MMMM 'de' yyyy", "lower_day_month"),
    ("divendres, DD de month de YYYY", "EEEE, dd 'de' MMMM 'de' yyyy", "lower_day_month"),
    ("day, ה-DD לmonth, YYYY", "EEEE, 'ה-'dd 'ל'MMMM, yyyy", "lower_day_month"),
    ("dD. MM. YYYY", "d. MM. yyyy", None),
    ("DD. mM. YYYY", "dd. M. yyyy", None),
    ("dD. mM. YYYY", "d. M. yyyy", None),
]

LANGUAGES = [
    "en", "fr", "es", "pt", "de", "de_AT", "it", "ca", "nl", "ru", "he", "el", "my", "id"
]

# Number of random samples per language/format
NUM_SAMPLES = 10

def capitalize_first(s):
    return s[0].upper() + s[1:] if s and s[0].islower() else s

def capitalize_month(s):
    # Capitalize first word (month), e.g. "august" -> "August"
    parts = s.split(" ")
    if parts:
        parts[0] = capitalize_first(parts[0])
    return " ".join(parts)

def lower_month(s):
    # Lowercase first word (month), e.g. "August" -> "august"
    parts = s.split(" ")
    if parts:
        parts[0] = parts[0].lower()
    return " ".join(parts)

def capitalize_day_month(s):
    # Capitalize day and month
    parts = s.split(" ")
    if parts:
        parts[0] = capitalize_first(parts[0])
        # Find month in the string (could be at position 2 or 3)
        for i in range(2,len(parts)):
            if len(parts[i]) > 2:  # crude check for month
                parts[i] = capitalize_first(parts[i])
                break
    return " ".join(parts)

def lower_day_month(s):
    # Lowercase day and month
    parts = s.split(" ")
    if parts:
        parts[0] = parts[0].lower()
        for i in range(2,len(parts)):
            if len(parts[i]) > 2:
                parts[i] = parts[i].lower()
                break
    return " ".join(parts)

def mmm_lower(s):
    # Lowercase short month (assume it's the 4th word, e.g., "Monday, 12 Jul 2004")
    parts = s.split(" ")
    if len(parts) >= 4:
        parts[3] = parts[3].lower()
    return " ".join(parts)

def MMM_cap(s):
    # Capitalize short month (assume it's the 4th word, e.g., "Monday, 12 Jul 2004")
    parts = s.split(" ")
    if len(parts) >= 4:
        parts[3] = capitalize_first(parts[3])
    return " ".join(parts)

POSTPROCESSORS = {
    "capitalize_month": capitalize_month,
    "lower_month": lower_month,
    "capitalize_day_month": capitalize_day_month,
    "lower_day_month": lower_day_month,
    "mmm_lower": mmm_lower,
    "MMM_cap": MMM_cap,
}

def typst_date(dt):
    return f"datetime(year: {dt.year}, month: {dt.month}, day: {dt.day})"

output_lines = [
    "// Auto-generated format coverage test",
    '#import "../src/formats.typ": custom-date-format'
]

random.seed(42)
for lang in LANGUAGES:
    # Fix Babel locale for Austrian German
    babel_lang = lang.replace("_", "-").replace("de_AT", "de-AT")
    for typst_fmt, babel_fmt, postproc_name in FORMAT_MAP:
        for _ in range(NUM_SAMPLES):
            dt = datetime(2000, 1, 1) + timedelta(days=random.randint(0, 10000))
            try:
                expected = format_date(dt, babel_fmt, locale=babel_lang)
                if postproc_name:
                    expected = POSTPROCESSORS[postproc_name](expected)
                # Escape double quotes and backslashes
                expected = expected.replace("\\", "\\\\").replace('"', '\\"')
                output_lines.append(
                    f'#assert(custom-date-format({typst_date(dt)}, "{typst_fmt}", "{lang}") == "{expected}")'
                )
            except Exception:
                continue

os.makedirs("../tests", exist_ok=True)
with open("../tests/test_generated_format_coverage.typ", "w", encoding="utf-8") as f:
    f.write("\n".join(output_lines) + "\n")

print("Generated Typst format coverage tests in ../tests/test_generated_format_coverage.typ")
