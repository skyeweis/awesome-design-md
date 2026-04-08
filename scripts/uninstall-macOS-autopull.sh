#!/usr/bin/env bash
set -euo pipefail
LABEL="com.skyeweis.minerva.awesome-design-md-pull"
PLIST_DEST="$HOME/Library/LaunchAgents/${LABEL}.plist"
if launchctl print "gui/$(id -u)/${LABEL}" &>/dev/null; then
  launchctl bootout "gui/$(id -u)" "$PLIST_DEST" 2>/dev/null || true
fi
rm -f "$PLIST_DEST"
echo "Removed Launch Agent ${LABEL}."
