#!/usr/bin/env bash
echo "Compiling grammar..."
./build.sh

echo "Testing Lexer..."
for f in $(find example -type f -name '*.css'); do
  echo -n "$f: "
  ./java/TestCSSLexer $f 2>err.log 1>/dev/null
  ERRORS=$(cat err.log | wc -l)
  if [ $ERRORS -gt 0 ]; then
    echo "FAIL"
    cat err.log
  else
    echo "OK"
  fi
done
