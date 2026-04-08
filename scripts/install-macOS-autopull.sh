#!/usr/bin/env bash
# Installs a Launch Agent that runs pull-from-github.sh daily (local time).
# Usage: ./scripts/install-macOS-autopull.sh
# Requires: macOS, write access to ~/Library/LaunchAgents
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
PULL_SCRIPT="$SCRIPT_DIR/pull-from-github.sh"
LABEL="com.skyeweis.minerva.awesome-design-md-pull"
PLIST_DEST="$HOME/Library/LaunchAgents/${LABEL}.plist"
LOG_DIR="$HOME/Library/Logs"
mkdir -p "$LOG_DIR"

chmod +x "$PULL_SCRIPT"

cat > "$PLIST_DEST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>${PULL_SCRIPT}</string>
  </array>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Hour</key>
    <integer>10</integer>
    <key>Minute</key>
    <integer>35</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>${LOG_DIR}/minerva-awesome-design-md-pull.log</string>
  <key>StandardErrorPath</key>
  <string>${LOG_DIR}/minerva-awesome-design-md-pull.err.log</string>
  <key>RunAtLoad</key>
  <false/>
</dict>
</plist>
EOF

# Reload if already loaded
if launchctl print "gui/$(id -u)/${LABEL}" &>/dev/null; then
  launchctl bootout "gui/$(id -u)" "$PLIST_DEST" 2>/dev/null || true
fi
launchctl bootstrap "gui/$(id -u)" "$PLIST_DEST"

echo "Installed Launch Agent: $PLIST_DEST"
echo "Runs daily at 10:35 local time. Logs: ${LOG_DIR}/minerva-awesome-design-md-pull.log"
echo "Test now: bash ${PULL_SCRIPT}"
