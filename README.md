# datify

Datify is a simple date package that allows users to format dates in new ways and addresses the issue of lacking date formats in different languages.

## Installation

```typst
#import "@preview/datify:0.1.1": day-name, month-name, written-date
```

## Reference

### day-name
Return the Name of the weekday.
#### Example

```typst
#import "@preview/datify:0.1.1": day-name

#day-name(2)
#day-name(1, lang: "fr", upper: true)
```

Output:

```
tuesday
Lundi
```

#### Parameters
```typst
day-name(weekday: int or str, lang: str, upper: boolean) --> str

```
|Parameter | Description | Default |
|--|--|--|
| weekday* | The weekday as an integer (1-7) or a string ("1"-"7"). | none |
| lang | An ISO 639-1 code representing the language. | en
| upper | A boolean that sets the first letter to be uppercase. | false |

\* required

### month-name

Returns the name of the month.

#### Example

```typst
#import "@preview/datify:0.1.1": month-name

#month-name(2)
#month-name(1, lang: "fr", upper: true)
```

Output:

```
february
Janvier
```

#### Parameters
```typst
month-name(month: int or str, lang: str = 'en', upper: bool = false) -> str
```
|Parameter | Description | Default |
|--|--|--|
| month* | The month as an integer (1-12) or a string ("1"-"12"). | none |
| lang | An ISO 639-1 code representing the language. | en
| upper | A boolean that sets the first letter to be uppercase. | false |

\* required

### written-date

Return the fully written date.

#### Example

```typst
#import "@preview/datify:0.1.1": written-date

#let my-date = (
    weekday: 4,
    day: 23,
    month: 5,
    year: 2024
)

#written-date(my-date)
#written-date(my-date, lang: "fr")

```

Output:

```
thursday 23 may 2024
jeudi 23 mai 2024
```

#### parameters

```typst
written-date(date, lang: str = 'en') --> content
```

The date must be a dictionary containing the following elements:

- weekday: An integer/string (1-7) representing the weekday.
- day: An integer representing the day of the month.
- month: An integer/string (1-12) representing the month.
- year: An integer representing the year.

Example of a date:
```typst
#let my-date = (
	weekday: 2
	day: 22
	month: 5
	year: 2024
)
```
# Supported language

| ISO 639-1 code | Status       |
|----------------|--------------|
| aa             | ❌           |
| ab             | ❌           |
| ae             | ❌           |
| af             | ❌           |
| ak             | ❌           |
| am             | ❌           |
| an             | ❌           |
| ar             | ❌           |
| as             | ❌           |
| av             | ❌           |
| ay             | ❌           |
| az             | ❌           |
| ba             | ❌           |
| be             | ❌           |
| bg             | ❌           |
| bh             | ❌           |
| bi             | ❌           |
| bm             | ❌           |
| bn             | ❌           |
| bo             | ❌           |
| br             | ❌           |
| bs             | ❌           |
| ca             | ❌           |
| ce             | ❌           |
| ch             | ❌           |
| co             | ❌           |
| cr             | ❌           |
| cs             | ❌           |
| cu             | ❌           |
| cv             | ❌           |
| cy             | ❌           |
| da             | ❌           |
| de             | ✅           |
| dv             | ❌           |
| dz             | ❌           |
| ee             | ❌           |
| el             | ❌           |
| en             | ✅           |
| eo             | ❌           |
| es             | ❌           |
| et             | ❌           |
| eu             | ❌           |
| fa             | ❌           |
| ff             | ❌           |
| fi             | ❌           |
| fj             | ❌           |
| fo             | ❌           |
| fr             | ✅           |
| fy             | ❌           |
| ga             | ❌           |
| gd             | ❌           |
| gl             | ❌           |
| gn             | ❌           |
| gu             | ❌           |
| gv             | ❌           |
| ha             | ❌           |
| he             | ❌           |
| hi             | ❌           |
| ho             | ❌           |
| hr             | ❌           |
| ht             | ❌           |
| hu             | ❌           |
| hy             | ❌           |
| hz             | ❌           |
| ia             | ❌           |
| id             | ❌           |
| ie             | ❌           |
| ig             | ❌           |
| ii             | ❌           |
| ik             | ❌           |
| io             | ❌           |
| is             | ❌           |
| it             | ❌           |
| iu             | ❌           |
| ja             | ❌           |
| jv             | ❌           |
| ka             | ❌           |
| kg             | ❌           |
| ki             | ❌           |
| kj             | ❌           |
| kk             | ❌           |
| kl             | ❌           |
| km             | ❌           |
| kn             | ❌           |
| ko             | ❌           |
| kr             | ❌           |
| ks             | ❌           |
| ku             | ❌           |
| kv             | ❌           |
| kw             | ❌           |
| ky             | ❌           |
| la             | ❌           |
| lb             | ❌           |
| lg             | ❌           |
| li             | ❌           |
| ln             | ❌           |
| lo             | ❌           |
| lt             | ❌           |
| lu             | ❌           |
| lv             | ❌           |
| mg             | ❌           |
| mh             | ❌           |
| mi             | ❌           |
| mk             | ❌           |
| ml             | ❌           |
| mn             | ❌           |
| mr             | ❌           |
| ms             | ❌           |
| mt             | ❌           |
| my             | ❌           |
| na             | ❌           |
| nb             | ❌           |
| nd             | ❌           |
| ne             | ❌           |
| ng             | ❌           |
| nl             | ❌           |
| nn             | ❌           |
| no             | ❌           |
| nr             | ❌           |
| nv             | ❌           |
| ny             | ❌           |
| oc             | ❌           |
| oj             | ❌           |
| om             | ❌           |
| or             | ❌           |
| os             | ❌           |
| pa             | ❌           |
| pi             | ❌           |
| pl             | ❌           |
| ps             | ❌           |
| pt             | ❌           |
| qu             | ❌           |
| rm             | ❌           |
| rn             | ❌           |
| ro             | ❌           |
| ru             | ❌           |
| rw             | ❌           |
| sa             | ❌           |
| sc             | ❌           |
| sd             | ❌           |
| se             | ❌           |
| sg             | ❌           |
| si             | ❌           |
| sk             | ❌           |
| sl             | ❌           |
| sm             | ❌           |
| sn             | ❌           |
| so             | ❌           |
| sq             | ❌           |
| sr             | ❌           |
| ss             | ❌           |
| st             | ❌           |
| su             | ❌           |
| sv             | ❌           |
| sw             | ❌           |
| ta             | ❌           |
| te             | ❌           |
| tg             | ❌           |
| th             | ❌           |
| ti             | ❌           |
| tk             | ❌           |
| tl             | ❌           |
| tn             | ❌           |
| to             | ❌           |
| tr             | ❌           |
| ts             | ❌           |
| tt             | ❌           |
| tw             | ❌           |
| ty             | ❌           |
| ug             | ❌           |
| uk             | ❌           |
| ur             | ❌           |
| uz             | ❌           |
| ve             | ❌           |
| vi             | ❌           |
| vo             | ❌           |
| wa             | ❌           |
| wo             | ❌           |
| xh             | ❌           |
| yi             | ❌           |
| yo             | ❌           |
| za             | ❌           |
| zh             | ❌           |
| zu             | ❌           |


# Planned
- Adding support for more language
- Adding new methods 
