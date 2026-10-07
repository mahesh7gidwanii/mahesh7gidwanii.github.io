#!/bin/bash
# ============================================
# 📄 push-resume.sh — One-command resume update
# ============================================
# Usage from Terminal:
#   bash push-resume.sh                       (uses existing resume.pdf in folder)
#   bash push-resume.sh "/path/to/new.pdf"    (copies new PDF then pushes)
# ============================================

set -e  # Exit on any error

# Always run from this script's directory (so it works wherever you click it from)
cd "$(dirname "$0")"

echo ""
echo "🚀 Resume push script — starting..."
echo ""

# ──────────────────────────────────────────────
# Step 1: If a file path was passed, copy it as resume.pdf
# ──────────────────────────────────────────────
if [ -n "$1" ]; then
  if [ ! -f "$1" ]; then
    echo "❌ ERROR: File not found at: $1"
    exit 1
  fi
  echo "📥 Copying new resume from:"
  echo "   $1"
  cp "$1" resume.pdf
  echo "✅ Saved as resume.pdf"
  echo ""
fi

# ──────────────────────────────────────────────
# Step 2: Verify resume.pdf exists
# ──────────────────────────────────────────────
if [ ! -f resume.pdf ]; then
  echo "❌ ERROR: No resume.pdf found in this folder."
  echo "   Drop your PDF here and rename it to resume.pdf,"
  echo "   OR run: bash push-resume.sh \"/path/to/your.pdf\""
  exit 1
fi

# ──────────────────────────────────────────────
# Step 3: Check if there are actually changes
# ──────────────────────────────────────────────
if git diff --quiet resume.pdf && git diff --cached --quiet resume.pdf; then
  echo "ℹ️  resume.pdf is unchanged — nothing to push."
  exit 0
fi

# ──────────────────────────────────────────────
# Step 4: Stage, commit, push
# ──────────────────────────────────────────────
DATE=$(date "+%B %Y")
echo "📦 Staging resume.pdf..."
git add resume.pdf

echo "💬 Committing..."
git commit -m "Update resume — $DATE"

echo "☁️  Pushing to GitHub..."
git push origin main

echo ""
echo "🎉 Done! Your new resume is live."
echo "   Live in 1–2 minutes at: https://mahesh7gidwanii.github.io/resume.pdf"
echo "   (hard refresh with Cmd+Shift+R)"
echo ""
