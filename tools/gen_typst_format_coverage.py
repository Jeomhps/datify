import random
from datetime import datetime, timedelta
from babel.dates import format_date
import os

# Map Typst format string to Babel format string and a "postprocess" function if needed
FORMAT_MAP = [
    # (Typst format, Babel format, capitalization)
    ("YYYY-MM-DD", "yyyy-MM-dd", None),
    ("MM/DD/YYYY", "MM/dd/yyyy", None),
    ("Month DD, YYYY", "MMMM dd, yyyy", "capitalize_month"),
    ("month DD, YYYY", "MMMM dd, yyyy", "lower_month"),
    ("YYYY-mM-dD", "yyyy-M-d", None),
    ("Day, DD Month YYYY", "EEEE, dd MMMM yyyy", "capitalize_day_month"),
    ("Day, DD mmm YYYY", "EEEE, dd MMM yyyy", "capitalize_day_month"),
    ("Day, DD MMM YYYY", "EEEE, dd MMM yyyy", "capitalize_day_month"),
    ("day, DD de month de YYYY", "EEEE, dd 'de' MMMM 'de' yyyy", "lower_day_month"),
    ("day, DD month YYYY", "EEEE, dd MMMM yyyy", "lower_day_month"),
    ("Day, DD Month YYYY", "EEEE, dd MMMM yyyy", "capitalize_day_month"),
]

LANGUAGES = [
    "en", "fr", "es", "pt", "de", "it", "ca", "nl", "ru", "he", "el", "my", "id", "de_AT"
]

# Number of random samples per language/format
NUM_SAMPLES = 10

def capitalize_first(s):
    return s[0].upper() + s[1:] if s and s[0].islower() else s

def capitalize_month(s):
    if not s:
        return s
    parts = s.split(" ")
    parts[0] = capitalize_first(parts[0])
    return " ".join(parts)

def lower_month(s):
    if not s:
        return s
    parts = s.split(" ")
    parts[0] = parts[0].lower()
    return " ".join(parts)

def capitalize_day_month(s):
    # capitalize first word (day), and capitalize month if present
    parts = s.split(" ")
    if parts:
        parts[0] = capitalize_first(parts[0])
        if len(parts) > 2:
            parts[2] = capitalize_first(parts[2])
    return " ".join(parts)

def lower_day_month(s):
    parts = s.split(" ")
    if parts:
        parts[0] = parts[0].lower()
        if len(parts) > 2:
            parts[2] = parts[2].lower()
    return " ".join(parts)

POSTPROCESSORS = {
    "capitalize_month": capitalize_month,
    "lower_month": lower_month,
    "capitalize_day_month": capitalize_day_month,
    "lower_day_month": lower_day_month,
}

def typst_date(dt):
    return f"datetime(year: {dt.year}, month: {dt.month}, day: {dt.day})"

output_lines = [
    "// Auto-generated format coverage test",
    '#import "../src/formats.typ": custom-date-format'
]

random.seed(42)
for lang in LANGUAGES:
    for typst_fmt, babel_fmt, postproc_name in FORMAT_MAP:
        for _ in range(NUM_SAMPLES):
            dt = datetime(2000, 1, 1) + timedelta(days=random.randint(0, 10000))
            babel_lang = lang.replace("_", "-").replace("de_AT", "de-AT")
            try:
                # Babel sometimes needs a valid locale, not all are installed
                expected = format_date(dt, babel_fmt, locale=babel_lang)
                if postproc_name:
                    expected = POSTPROCESSORS[postproc_name](expected)
                # Escape double quotes and backslashes
                expected = expected.replace("\\", "\\\\").replace('"', '\\"')
                output_lines.append(
                    f'#assert(custom-date-format({typst_date(dt)}, "{typst_fmt}", "{lang}") == "{expected}")'
                )
            except Exception as e:
                # If Babel doesn't support the locale/format, skip
                continue

# Output file, adjust path as needed
os.makedirs("../tests", exist_ok=True)
with open("../tests/test_generated_format_coverage.typ", "w", encoding="utf-8") as f:
    f.write("\n".join(output_lines) + "\n")

print("Generated Typst format coverage tests in ../tests/test_generated_format_coverage.typ")
