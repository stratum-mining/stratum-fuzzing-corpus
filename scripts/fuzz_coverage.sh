#!/usr/bin/env bash
set -euo pipefail

############################################
# Tools must be available directly in PATH:
#   llvm-profdata
#   llvm-cov
############################################

PROJECT_ROOT="$(pwd)"
HOST_TARGET=$(rustc +nightly --print host-tuple)

echo "[+] Project root: $PROJECT_ROOT"
echo "[+] Host target: $HOST_TARGET"

############################################
# 1. Run coverage for all fuzz targets
############################################

echo "[+] Running fuzz coverage"
for target in $(cargo +nightly fuzz list); do
    echo "   → $target"
    cargo +nightly fuzz coverage "$target"
done

############################################
# 2. Merge all .profdata
############################################

echo "[+] Merging coverage profiles"
llvm-profdata merge -sparse \
    fuzz/coverage/*/coverage.profdata \
    -o fuzz/coverage/merged.profdata

############################################
# 3. Collect fuzz target coverage binaries
############################################

echo "[+] Collecting fuzz binaries"

OBJECTS=""
FIRST_TARGET=""

for target in $(cargo fuzz list); do
    BIN="target/$HOST_TARGET/coverage/$HOST_TARGET/release/$target"

    if [ ! -f "$BIN" ]; then
        echo "ERROR: expected binary not found: $BIN"
        exit 1
    fi

    if [ -z "$FIRST_TARGET" ]; then
        FIRST_TARGET="$BIN"
    else
        OBJECTS="$OBJECTS -object $BIN"
    fi
done

############################################
# 4. Filtering rules:
#    - ignore stdlib (/rustc/…)
#    - ignore crates.io (~/.cargo/registry/…)
#    - ignore everything outside the project dir
############################################

IGNORE_FLAGS=(
    "-ignore-filename-regex=/.*/rustc/.*"
    "-ignore-filename-regex=/.cargo/registry/.*"
    "-ignore-filename-regex=^/(?!${PROJECT_ROOT}).*$"
)

############################################
# 5. Generate text summary
############################################

echo "[+] Generating text summary"
llvm-cov report \
    "${IGNORE_FLAGS[@]}" \
    -instr-profile=fuzz/coverage/merged.profdata \
    $FIRST_TARGET $OBJECTS \
    > coverage_summary.txt

############################################
# 6. Generate HTML report
############################################

echo "[+] Generating HTML report"
llvm-cov show \
    "${IGNORE_FLAGS[@]}" \
    -instr-profile=fuzz/coverage/merged.profdata \
    $FIRST_TARGET $OBJECTS \
    -format=html \
    -output-dir=coverage_html

echo "[✓] Done!"
echo "HTML → coverage_html/index.html"
echo "TXT  → coverage_summary.txt"

