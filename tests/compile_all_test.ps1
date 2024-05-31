gci -Filter *.typ | % { typst compile --root .. $_.FullName }
