#!/usr/bin/env bash
set -e

PACKAGE=$(grep '^name:' pubspec.yaml | sed 's/name:[[:space:]]*//')

TEST_DIR="test"
TEST_FILE="$TEST_DIR/${PACKAGE}_coverage_loader_test.dart"
TMP_FILE="$TEST_FILE.tmp"

mkdir -p "$TEST_DIR"

echo "// GENERATED FILE — DO NOT EDIT" > "$TMP_FILE"
echo "" >> "$TMP_FILE"
echo "// ignore_for_file: unused_import" >> "$TMP_FILE"
echo "import 'package:flutter_test/flutter_test.dart';" >> "$TMP_FILE"
echo "" >> "$TMP_FILE"

find lib -type f -name '*.dart' \
  ! -name '*.g.dart' \
  ! -name '*.freezed.dart' \
  ! -path '*/generated/*' \
| sort \
| sed "s|^lib/|import 'package:$PACKAGE/|; s|$|';|" \
>> "$TMP_FILE"

echo "" >> "$TMP_FILE"
echo "void main() {}" >> "$TMP_FILE"

mv "$TMP_FILE" "$TEST_FILE"

echo "Coverage loader generated: $TEST_FILE"
