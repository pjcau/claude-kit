#!/usr/bin/env bash
set -euo pipefail

# Build a .deb package for claude-kit
# Usage: ./packaging/deb/build-deb.sh [version]
# Example: ./packaging/deb/build-deb.sh 0.1.3

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

VERSION="${1:-}"
if [[ -z "$VERSION" ]]; then
    # Try to extract from git tag
    VERSION="$(git -C "$REPO_ROOT" describe --tags --abbrev=0 2>/dev/null | sed 's/^v//')" \
        || { echo "Error: no version specified and no git tag found"; exit 1; }
fi

PKG_NAME="claude-kit"
BUILD_DIR="$(mktemp -d)"
PKG_DIR="$BUILD_DIR/${PKG_NAME}_${VERSION}_all"

echo "Building ${PKG_NAME}_${VERSION}_all.deb ..."

# Create directory structure
mkdir -p "$PKG_DIR/DEBIAN"
mkdir -p "$PKG_DIR/usr/bin"
mkdir -p "$PKG_DIR/usr/share/claude-kit"

# Copy control file and substitute version
sed "s/__VERSION__/$VERSION/" "$SCRIPT_DIR/DEBIAN/control" > "$PKG_DIR/DEBIAN/control"

# Install binary
install -m 755 "$REPO_ROOT/bin/claude-kit" "$PKG_DIR/usr/bin/claude-kit"

# Install data files (skills, agents, hooks, templates, settings)
for dir in skills agents hooks templates; do
    if [[ -d "$REPO_ROOT/$dir" ]]; then
        cp -r "$REPO_ROOT/$dir" "$PKG_DIR/usr/share/claude-kit/"
    fi
done
if [[ -f "$REPO_ROOT/settings.json" ]]; then
    cp "$REPO_ROOT/settings.json" "$PKG_DIR/usr/share/claude-kit/"
fi

# Patch the `cmd_list` function to find data in /usr/share/claude-kit
# The script already checks $(brew --prefix)/share/claude-kit, we add /usr/share too
# This is handled at runtime — the binary checks standard paths

# Set permissions
find "$PKG_DIR" -type d -exec chmod 755 {} \;
find "$PKG_DIR/usr/share" -type f -exec chmod 644 {} \;
chmod 755 "$PKG_DIR/usr/bin/claude-kit"
# Make hook scripts executable
find "$PKG_DIR/usr/share/claude-kit/hooks" -name "*.sh" -exec chmod 755 {} \; 2>/dev/null || true

# Build the package
dpkg-deb --build --root-owner-group "$PKG_DIR"

# Move to output
OUTPUT_DIR="$REPO_ROOT/dist"
mkdir -p "$OUTPUT_DIR"
mv "$PKG_DIR.deb" "$OUTPUT_DIR/"

# Cleanup
rm -rf "$BUILD_DIR"

echo "Package built: dist/${PKG_NAME}_${VERSION}_all.deb"
