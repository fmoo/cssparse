#!/usr/bin/env bash
antlr CSS.g -o java
pushd java >/dev/null
javac *.java -cp ../../antlr-3.4/lib/antlr-3.4-complete.jar
popd >/dev/null
