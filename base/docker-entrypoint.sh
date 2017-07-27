#!/usr/bin/env bash

# fail hard
set -o pipefail
# fail harder
set -exu

# Render templates from /var/nginx/templates
gomplate --input-dir=/var/templates/nginx --output-dir=/etc/nginx/conf.d/

cd $PROJECT_DIR
exec forego start