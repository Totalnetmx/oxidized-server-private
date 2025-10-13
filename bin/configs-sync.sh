#!/usr/bin/env bash
set -euo pipefail

LOGP="[configs-sync]"
echo "$LOGP start $(date -Iseconds)"

SRC="/opt/obs/oxidized"
DST="/opt/obs/oxidized-config-private"

if [ ! -d "$DST/.git" ]; then
  echo "$LOGP ERROR: $DST no es repo git"
  exit 1
fi

# sincroniza sólo lo necesario y excluye efímeros
rsync -a --delete \
  --exclude='.git/' \
  --exclude='.gitignore' \
  --exclude='logs/' \
  --exclude='config/crash/' \
  --exclude='config/pid' \
  --exclude='*/pid' \
  --exclude='pid' \
  "$SRC/docker-compose.yaml" \
  "$SRC/router.db" \
  "$SRC/config/" \
  "$DST/"

cd "$DST"
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_github -o IdentitiesOnly=yes"

git add -A
if ! git diff --cached --quiet; then
  echo "$LOGP cambios detectados, commit & push..."
  git commit -m "configs sync: $(date -Iseconds)"
  git push origin main
else
  echo "$LOGP sin cambios"
fi

echo "$LOGP done"
