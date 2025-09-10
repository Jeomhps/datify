# Datify

![Test Datify](https://github.com/Jeomhps/datify/actions/workflows/test.yml/badge.svg?branch=main)

> **⚠️ Major Breaking Changes in v0.1.4+**  
> Datify has been completely rewritten.  
> - The old API (`day-name`, `month-name`, etc.) no longer exists.
> - The `custom-date-format` function has a new signature and new format tokens.
> - Positional arguments are no longer supported.
> - If you are migrating from a previous version, you **must update your code**.  
> - The old usage is **not compatible** with this version.
>
> Please read this README carefully to update your usage.

---

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Usage](#usage)
   - [Formatting Dates](#formatting-dates)
   - [Format Tokens](#format-tokens)
   - [Named Patterns](#named-patterns)
   - [Literal Text in Patterns](#literal-text-in-patterns)
4. [Supported Languages](#supported-languages)
5. [Contributing](#contributing)
6. [License](#license)
7. [Development & Testing](#development--testing)
8. [Planned Features](#planned-features)

---

## Overview

Datify is a Typst package for flexible, locale-aware date formatting.  
It leverages [datify-core](https://github.com/Jeomhps/datify-core) for internationalization and supports CLDR-style date patterns.

---

## Installation

Add Datify to your Typst project:

```typst
#import "@preview/datify:0.1.4": custom-date-format
```

---

## Usage

### Formatting Dates

The main entrypoint is `custom-date-format`.  
It formats a `datetime` object according to a pattern and language.

#### Example

```typst
#import "@preview/datify:0.1.4": custom-date-format

#let my-date = datetime(year: 2025, month: 1, day: 5)
#custom-date-format(my-date, pattern: "EEEE, MMMM dd, yyyy") 
// Output: Sunday, January 05, 2025

#custom-date-format(my-date, pattern: "dd/MM/yyyy", lang: "fr")
// Output: 05/01/2025
```

#### Signature

```typst
custom-date-format(date: datetime, pattern: str = "full", lang: str = "en") -> str
```

- `date`: The date to format (must be a Typst `datetime` object)
- `pattern`: The format string (see [Format Tokens](#format-tokens) below)
- `lang`: ISO 639-1 language code (e.g., `"en"`, `"fr"`, `"es"`)

---

### Format Tokens

The following tokens are supported in the pattern string:

| Token   | Description                        | Example Output      |
|---------|------------------------------------|---------------------|
| `EEEE`  | Full weekday name                  | Sunday              |
| `EEE`   | Abbreviated weekday name           | Sun                 |
| `MMMM`  | Full month name                    | January             |
| `MMM`   | Abbreviated month name             | Jan                 |
| `MM`    | Month number, 2 digits             | 01                  |
| `M`     | Month number, 1-2 digits           | 1                   |
| `dd`    | Day of month, 2 digits             | 05                  |
| `d`     | Day of month, 1-2 digits           | 5                   |
| `yyyy`  | 4-digit year                       | 2025                |
| `y`     | Year (same as `yyyy`)              | 2025                |

**Note:**  
- Tokens are case-sensitive.
- Only the tokens above are supported.

#### Example Patterns

```typst
#custom-date-format(my-date, pattern: "yyyy-MM-dd") // 2025-01-05
#custom-date-format(my-date, pattern: "EEE, MMM d, yyyy") // Sun, Jan 5, 2025
```

---

### Named Patterns

You can use CLDR-style named patterns: `"full"`, `"long"`, `"medium"`, `"short"`.  
These will be resolved to locale-appropriate patterns for the given language.

```typst
#custom-date-format(my-date, pattern: "full", lang: "es")
// Output: domingo, 5 de enero de 2025
```

---

### Literal Text in Patterns

To include literal text, wrap it in single quotes (`'`).  
To include a single quote, use two single quotes (`''`).

```typst
#custom-date-format(my-date, pattern: "'Today is' EEEE") // Today is Sunday
#custom-date-format(my-date, pattern: "yyyy'/'MM'/'dd") // 2025/01/05
#custom-date-format(my-date, pattern: "'''quoted'''")   // 'quoted'
```

---

## Supported Languages

Datify supports all languages provided by [datify-core](https://github.com/Jeomhps/datify-core).  
If you pass an unsupported language code, an error will be thrown.

**Common supported codes:**  
- `en` (English)
- `fr` (French)
- `de` (German)
- `es` (Spanish)
- `pt` (Portuguese)
- `ru` (Russian)
- `el` (Greek)
- `he` (Hebrew)
- `id` (Indonesian)
- `it` (Italian)
- `nl` (Dutch)
- `my` (Burmese)

See [datify-core](https://github.com/Jeomhps/datify-core) for the full list.

---

## Testing

To run the full test suite locally, you have two options:

1. **Manual (recommended for contributors)**
    - Install [tt (tytanic)](https://github.com/taiki-e/tytanic) to run the Typst tests

    ```sh
    tt run
    ```

2. **Via GitHub Actions workflow locally**
    - Install [act](https://github.com/nektos/act)
    - Run the CI workflow as it appears in `.github/workflows/test.yml`:

    ```sh
    act --artifact-server-path /tmp/artifact
    ```

---

## Contributing

- **Native speakers wanted!** If you notice missing or incorrect translations for a language, please contribute directly to [datify-core](https://github.com/Jeomhps/datify-core), which manages all locale data for Datify.
- Pull requests for bug fixes, improvements to this package, ideas, or feedback are welcome here.
- For upstream locale data and structure, see [cldr-json](https://github.com/unicode-org/cldr-json).
- If you wish to run tests, see the [Testing](#testing) section above for setup.

---

## License

MIT © 2025 Jeomhps  
CLDR data © Unicode, Inc., used under the [Unicode License](https://unicode.org/copyright.html).

---

## Credits

- [Unicode CLDR Project](https://cldr.unicode.org/)
- [cldr-json](https://github.com/unicode-org/cldr-json)
- [tytanic](https://github.com/taiki-e/tytanic) (Typst test runner)
- [datify-core](https://github.com/Jeomhps/datify-core) (Locale and formatting backend)

---