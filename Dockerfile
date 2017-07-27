FROM pihvio/php-nginx-base

COPY . ${PROJECT_DIR}/

RUN composer install --no-dev