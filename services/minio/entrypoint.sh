#!/bin/sh

mc config host add minio http://minio:9000 minioadmin minioadmin
echo "設定を反映しています..."; sleep 1

mc admin user add minio openobserve openobserve
mc admin policy attach minio readwrite --user openobserve
mc admin user svcacct add minio openobserve
mc mb --with-lock --with-versioning minio/files
