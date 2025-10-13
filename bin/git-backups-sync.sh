#!/usr/bin/env bash
set -euo pipefail

cd /opt/obs/oxidized/backup-equipos

# Asegurar remote configurado
git remote -v >/dev/null

# Usar tu llave de GitHub
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_github -o IdentitiesOnly=yes"

git add -A
if ! git diff --cached --quiet; then
  git commit -m "backup: $(date -Iseconds)"
  git push origin main
fi
