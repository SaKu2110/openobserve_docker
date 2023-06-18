#!/bin/sh

gum spin --spinner dot --title "minio コンテナ作成中..." \
  -- docker compose up prometheus cadvisor -d

docker compose restart openobserve
