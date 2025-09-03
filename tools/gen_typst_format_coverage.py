import random
from datetime import datetime, timedelta
from babel.dates import get_month_names, format_date
import os
import re

LANGUAGES = [
    "en", "fr", "es", "pt", "de", "de_AT", "it", "ca", "nl", "ru", "he", "el", "my", "id"
]

NUM_SAMPLES = 10

FORMAT_PATTERNS = [
    ("Day, DD Month YYYY", ["Day", "DD", "Month", "YYYY"]),
    ("day, DD month YYYY", ["day", "DD", "month", "YYYY"]),
    ("DAY, DD MONTH YYYY", ["DAY", "DD", "MONTH", "YYYY"]),
    ("Day, DD MMM YYYY", ["Day", "DD", "MMM", "YYYY"]),
    ("day, DD mmm YYYY", ["day", "DD", "mmm", "YYYY"]),
    ("DAY, DD MMMM YYYY", ["DAY", "DD", "MMMM", "YYYY"]),
    ("YYYY-MM-DD", ["YYYY", "MM", "DD"]),
    ("MM/DD/YYYY", ["MM", "DD", "YYYY"]),
    ("YYYY-mM-dD", ["YYYY", "mM", "dD"]),
    ("dD. MM. YYYY", ["dD", "MM", "YYYY"]),
    ("DD. mM. YYYY", ["DD", "mM", "YYYY"]),
    ("dD. mM. YYYY", ["dD", "mM", "YYYY"]),
    ("YY/MM/dD", ["YY", "MM", "dD"]),
]

# Flags to control whether Catalan, Hebrew, Greek, and Burmese tests are enabled
ENABLE_CA_TESTS = False
ENABLE_HE_TESTS = False  # Hebrew
ENABLE_EL_TESTS = False  # Greek
ENABLE_MY_TESTS = False  # Burmese

def _strip_de_prefix(s):
    s = s.lstrip()
    if s.lower().startswith("de "):
        return s[3:]
    if s.lower().startswith("d’") or s.lower().startswith("d'"):
        return s[2:]
    return s

def _capitalize_first(s):
    if not s:
        return s
    return s[0].upper() + s[1:] if s[0].islower() else s

def _upper(s):
    return s.upper() if s else s

def _lower(s):
    return s.lower() if s else s

def _short_month_from_full(month_full):
    # Naive: just use the first 3 characters, mimicking the runtime implementation
    return month_full[:3]

def process_placeholder(placeholder, dt, lang, day_full, month_full):
    mf = _strip_de_prefix(month_full)
    ms = _short_month_from_full(mf)  # Use first 3 characters for abbreviation

    # Special Hebrew logic: strip "יום " prefix for day names if present
    if lang == "he":
        if day_full.startswith("יום "):
            day_full = day_full[4:]

    # (Greek "el" and Burmese "my" special casing could be added here in future if needed.)

    if placeholder == "day":
        return _lower(day_full)
    if placeholder == "Day":
        return _capitalize_first(day_full)
    if placeholder == "DAY":
        return _upper(day_full)
    if placeholder == "month":
        return _lower(mf)
    if placeholder == "Month":
        return _capitalize_first(mf)
    if placeholder == "MONTH":
        return _upper(mf)
    if placeholder == "mmm":
        return _lower(ms)
    if placeholder == "MMM":
        return _capitalize_first(ms)
    if placeholder == "MMMM":
        return _capitalize_first(mf)
    if placeholder == "DD":
        return str(dt.day).zfill(2)
    if placeholder == "dD":
        return str(int(dt.day))
    if placeholder == "MM":
        return str(dt.month).zfill(2)
    if placeholder == "mM":
        return str(int(dt.month))
    if placeholder == "YYYY":
        return str(dt.year)
    if placeholder == "YY":
        return str(dt.year)[-2:]
    return ""

PLACEHOLDER_REGEX = re.compile(
    r"(YYYY|YY|MMMM|MMM|mmm|MONTH|Month|month|MM|mM|DD|dD|DAY|Day|day)"
)

def build_expected_string(typst_fmt, dt, lang):
    babel_lang = lang.replace("_", "-").replace("de_AT", "de-AT")
    day_full = format_date(dt, "EEEE", locale=babel_lang)
    months_full = get_month_names('wide', locale=babel_lang)
    month_full = months_full[dt.month]
    def repl(match):
        key = match.group(1)
        return process_placeholder(key, dt, lang, day_full, month_full)
    result = PLACEHOLDER_REGEX.sub(repl, typst_fmt)
    return result

def typst_date(dt):
    return f"datetime(year: {dt.year}, month: {dt.month}, day: {dt.day})"

output_lines = [
    "// Auto-generated format coverage test",
    '#import "../src/formats.typ": custom-date-format'
]

random.seed(42)
for lang in LANGUAGES:
    if lang == "ca" and not ENABLE_CA_TESTS:
        continue
    if lang == "he" and not ENABLE_HE_TESTS:
        continue
    if lang == "el" and not ENABLE_EL_TESTS:
        continue
    if lang == "my" and not ENABLE_MY_TESTS:
        continue
    for typst_fmt, _ in FORMAT_PATTERNS:
        for _ in range(NUM_SAMPLES):
            dt = datetime(2000, 1, 1) + timedelta(days=random.randint(0, 10000))
            try:
                expected = build_expected_string(typst_fmt, dt, lang)
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
