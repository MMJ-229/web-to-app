#!/usr/bin/env bash
# find-gradle-root.sh
# Prints the directory that contains a Gradle wrapper (gradlew) and a
# settings.gradle(.kts) file.  Searches the repo root first, then one
# level of common Android subdirectories (android/, app/, project/).
# Exits 1 if no Gradle root can be located.

set -euo pipefail

REPO_ROOT="${1:-$(git -C "$(dirname "$0")" rev-parse --show-toplevel 2>/dev/null || pwd)}"

is_gradle_root() {
  local dir="$1"
  [ -f "$dir/gradlew" ] && \
    { [ -f "$dir/settings.gradle" ] || [ -f "$dir/settings.gradle.kts" ]; }
}

# 1. Check repo root first
if is_gradle_root "$REPO_ROOT"; then
  echo "$REPO_ROOT"
  exit 0
fi

# 2. Check common subdirectory names
for subdir in android app project; do
  candidate="$REPO_ROOT/$subdir"
  if is_gradle_root "$candidate"; then
    echo "$candidate"
    exit 0
  fi
done

echo "ERROR: Could not locate a Gradle project (gradlew + settings.gradle) under $REPO_ROOT" >&2
exit 1
