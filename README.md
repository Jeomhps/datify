# Datify

![Test Datify](https://github.com/Jeomhps/datify/actions/workflows/test.yml/badge.svg?branch=main)

> **⚠️ Major Breaking Changes in v1.0.0+**
>
> - The user-facing API of Datify has been completely rewritten.
> - Functions like `day-name`, `month-name`, etc. are **no longer available directly in Datify**.  
>   They have been moved to [datify-core](https://github.com/Jeomhps/datify-core), which Datify uses as its backend.
> - The new backend is based on the [Unicode CLDR project](https://cldr.unicode.org/), providing robust internationalization.
> - If you need to resolve a single day or month name, it is recommended to use `datify-core` directly.  
>   You can also use `custom-date-format` for this, but it is less practical for single values.
> - The core logic for string transformation now uses a formal language and automata approach, similar to many modern date libraries.  
>   This introduces a new quoting system for escaping text in patterns.
> - **If you are migrating from a previous version, your code will need to be updated.**  
>   The old usage is not compatible with this version.

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

Add Datify to your Typst project (specify the version you want):

```typst
#import "@preview/datify:1.0.0": *
```

---

## Usage

### Function Reference

| Argument | Type      | Required | Default | Description                                      |
|----------|-----------|----------|---------|--------------------------------------------------|
| date     | datetime  | Yes      | –       | The date to format                               |
| pattern  | str       | No       | "full"  | Pattern string or CLDR named pattern             |
| lang     | str       | No       | "en"    | ISO 639-1 language code (e.g., "en", "fr", "es") |

**If you only provide `lang`, the pattern defaults to `"full"` for that locale. All arguments must be named except for the first (`date`).**

#### Example usage

```typst
#let mydate = datetime(year: 2025, month: 1, day: 5)
#custom-date-format(mydate)
#custom-date-format(mydate, lang: "es")
#custom-date-format(mydate, pattern: "yyyy-MM-dd")
#custom-date-format(mydate, pattern: "full", lang: "fr")
```

#### Example

```typst
#let mydate = datetime(year: 2025, month: 1, day: 5)
#custom-date-format(mydate) // Output: Sunday, January 5, 2025 (in English, full format)
#custom-date-format(mydate, lang: "es") // Output: domingo, 5 de enero de 2025
#custom-date-format(mydate, pattern: "yyyy-MM-dd") // Output: 2025-01-05
```

---

### Pattern Syntax

- The `pattern` argument can be either:
  - A **CLDR named pattern** (`"full"`, `"long"`, `"medium"`, `"short"`) for locale-appropriate formatting.
  - A **custom string pattern** using the tokens below.

#### CLDR Pattern Example

```typst
#custom-date-format(mydate, pattern: "full", lang: "fr")
// Output: dimanche 5 janvier 2025
```

#### Custom Pattern Example

```typst
#custom-date-format(mydate, pattern: "EEEE, MMMM dd, yyyy")
// Output: Sunday, January 05, 2025
```

---

### Format Tokens

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

- **Tokens are case-sensitive.**
- Only the tokens above are supported.

---

### Named Patterns (CLDR)

- `"full"`, `"long"`, `"medium"`, `"short"` are mapped to locale-specific patterns using CLDR data.
- This is a major improvement over previous versions and ensures internationalization best practices.

---

### Literal Text & Escaping

- To include literal text in your pattern, wrap it in single quotes (`'`).
- To include a single quote, use two single quotes (`''`).
- **While you can sometimes include text without quotes, it is strongly recommended to quote any literal text to avoid accidental transformation by the pattern parser.**
- The new parser uses a formal automata-based approach, similar to many modern date libraries, which is why quoting is important.

#### Examples

```typst
#custom-date-format(mydate, pattern: "'Today is' EEEE") // Today is Sunday
#custom-date-format(mydate, pattern: "yyyy'/'MM'/'dd") // 2025/01/05
#custom-date-format(mydate, pattern: "'''quoted'''")   // 'quoted'
```

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