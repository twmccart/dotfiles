#!/usr/bin/env bash

set -e

if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo."
    exit 1
fi

EVDEV_XML="/usr/share/X11/xkb/rules/evdev.xml"
PATCH_SCRIPT="/usr/local/sbin/patch-evdev-carpalx"
APT_HOOK="/etc/apt/apt.conf.d/99carpalx-xkb"

echo "=== Installing Carpalx evdev.xml patch system ==="

############################################
# 1. Install patch script
############################################

cat > "$PATCH_SCRIPT" << 'EOF'
#!/usr/bin/env bash
set -e

EVDEV_XML="/usr/share/X11/xkb/rules/evdev.xml"

[ -f "$EVDEV_XML" ] || exit 0

# Already patched?
if awk '
/<layout>/ { in_layout=1; in_us=0 }
/<\/layout>/ { in_layout=0; in_us=0 }
/<name>us<\/name>/ && in_layout { in_us=1 }
/<name>carpalx<\/name>/ && in_layout && in_us { found=1 }
END { exit !found }
' "$EVDEV_XML"
then
    exit 0
fi

awk '
BEGIN { in_layout=0; in_us=0; inserted=0 }

/<layout>/ {
    in_layout=1
    in_us=0
}

/<\/layout>/ {
    in_layout=0
    in_us=0
}

/<name>us<\/name>/ && in_layout {
    in_us=1
}

/<variantList>/ && in_layout && in_us && !inserted {
    print
    print "        <variant>"
    print "          <configItem>"
    print "            <name>carpalx</name>"
    print "            <description>English (Carpalx)</description>"
    print "          </configItem>"
    print "        </variant>"
    inserted=1
    next
}

{ print }

END {
    if (!inserted) {
        print "ERROR: Failed to insert carpalx variant." > "/dev/stderr"
        exit 1
    }
}
' "$EVDEV_XML" > "${EVDEV_XML}.new"

mv "${EVDEV_XML}.new" "$EVDEV_XML"
EOF

chmod +x "$PATCH_SCRIPT"

############################################
# 2. Install dpkg Post-Invoke hook
############################################

cat > "$APT_HOOK" << EOF
DPkg::Post-Invoke { "$PATCH_SCRIPT || true"; };
EOF

############################################
# 3. Apply patch immediately
############################################

"$PATCH_SCRIPT"

echo "=== Done ==="
echo "Log out and back in, or restart xfsettingsd."
