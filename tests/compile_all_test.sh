#!/bin/sh
set -e

fail=0

for file in *.typ; do
  echo "Testing $file..."
  if typst compile --root .. "$file"; then
    echo "✅ $file PASSED"
  else
    echo "❌ $file FAILED"
    fail=1
  fi
done

if [ "$fail" -ne 0 ]; then
  echo "Some tests failed."
  exit 1
else
  echo "All tests passed!"
fi
