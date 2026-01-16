#!/bin/bash
set -e

# 로그 남기기
exec > /var/log/user-data.log 2>&1

SOURCE_AUTH_KEYS="/home/ubuntu/.ssh/authorized_keys"
USERS="hansu minji hoju jisu"

# ubuntu 계정의 authorized_keys가 존재하는지 확인
if [ ! -f "$SOURCE_AUTH_KEYS" ]; then
  echo "[$(date)] $SOURCE_AUTH_KEYS not found, skipping copy"
  exit 0
fi

for u in $USERS; do
  echo "[$(date)] Setting up SSH for user: $u"

  # 유저 없으면 생성
  if ! id -u "$u" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$u"
  fi

  HOME_DIR=$(getent passwd "$u" | cut -d: -f6)
  SSH_DIR="$HOME_DIR/.ssh"
  AUTH_KEYS="$SSH_DIR/authorized_keys"

  mkdir -p "$SSH_DIR"

  # ubuntu의 authorized_keys를 그대로 복제
  cat "$SOURCE_AUTH_KEYS" > "$AUTH_KEYS"

  chown -R "$u:$u" "$SSH_DIR"
  chmod 700 "$SSH_DIR"
  chmod 600 "$AUTH_KEYS"
done
