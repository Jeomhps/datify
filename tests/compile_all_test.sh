#! /bin/sh
find . -name "*.typ" -exec typst compile --root .. {} \;
