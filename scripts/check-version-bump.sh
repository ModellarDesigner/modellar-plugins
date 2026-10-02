#!/bin/sh
# Fails when a plugin's files change but its plugin.json "version" does not.
#
# Installed copies of a plugin update only when that version string changes, so
# a change pushed without a bump silently never reaches users.
#
#   scripts/check-version-bump.sh          staged changes vs HEAD (pre-commit hook)
#   scripts/check-version-bump.sh <base>   HEAD vs <base> (CI)

base="$1"

version_of() { # <git object spec> -> the "version" value, or empty
  git show "$1" 2>/dev/null |
    sed -n 's/.*"version"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1
}

if [ -n "$base" ]; then
  changed=$(git diff --name-only "$base" HEAD -- plugins/)
  new_ref="HEAD:"
  old_ref="$base:"
else
  changed=$(git diff --cached --name-only -- plugins/)
  new_ref=":"
  old_ref="HEAD:"
fi

[ -z "$changed" ] && exit 0

status=0
for plugin in $(printf '%s\n' "$changed" | cut -d/ -f2 | sort -u); do
  manifest="plugins/$plugin/.claude-plugin/plugin.json"
  old=$(version_of "$old_ref$manifest")
  new=$(version_of "$new_ref$manifest")
  # A new plugin has nothing to compare against. A plugin without a version is
  # versioned by commit, so every commit already reaches users.
  [ -z "$old" ] || [ -z "$new" ] && continue
  if [ "$old" = "$new" ]; then
    echo "error: plugins/$plugin changed but its version is still $old." >&2
    echo "       Bump \"version\" in $manifest, or users will not get the change." >&2
    status=1
  fi
done
exit $status
