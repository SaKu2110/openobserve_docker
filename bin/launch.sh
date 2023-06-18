#!/bin/sh

gum spin --spinner dot --title "minio コンテナ作成中..." \
  -- docker compose up minio minio-setup -d

until (docker compose ps -a minio-setup | grep Exited >> /dev/null)
do 
  gum spin --spinner dot --title "minio 設定中..." \
    -- sleep 1
done
KEYS=$(
  docker compose logs minio-setup \
    | grep -e 'Access Key' -e 'Secret Key' \
    | awk -F '[:]' '{ print $2 }' \
    | sed 's/ //g'
)
ACCESS_KEY=$(echo $KEYS | awk -F '[ ]' '{ print $1 }')
SECRET_KEY=$(echo $KEYS | awk -F '[ ]' '{ print $2 }')

sed -i "/^ZO_S3_ACCESS_KEY=/c\ZO_S3_ACCESS_KEY=${ACCESS_KEY}" services/openobserve/.env
sed -i "/^ZO_S3_SECRET_KEY=/c\ZO_S3_SECRET_KEY=${SECRET_KEY}" services/openobserve/.env

gum spin --spinner dot --title "minio コンテナ作成中..." \
  -- docker compose up openobserve -d
