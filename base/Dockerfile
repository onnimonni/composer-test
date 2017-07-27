FROM pihvio/base:alpine

RUN \
	# Enable testing repositories for custom php7-* extensions
	echo "http://dl-4.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
	# Install nginx and timezone data
	&& apk add --update \
	# Needed for sendmail wrapper and other scripts
	bash \
	# Useful for debugging against localhost
	curl \
	# Needed for ssh:// packages with composer
	git \
	openssh-client \
	# For debugging something inside the container
	nano \
	# This is used to parse the composer.lock platfrom dependencies
	jq \
	# Nginx
	nginx ca-certificates \
    # WP-CLI uses ncurses and will cause error notices in output when not installed
    ncurses \
    # WP-CLI uses less for displaying help
    less \
    # For sending emails
    msmtp \
    # For mysql import/export
    mysql-client \

 	# Then add few fixes
	# Give nginx user permissions to run stuff
	&& chown nginx:www-data /var/run \
	# Symlink the default log files to stdout
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \

	# Remove default nginx configs
	&& rm /etc/nginx/conf.d/default.conf \

	# Allow any user to write nginx startup files
	# (This is requirement for heroku, since they might use different user uid)
	&& chmod 0777 /etc/nginx/conf.d

ADD rootfs /

# Install the project to this folder
ENV	PROJECT_DIR=/var/www/project
ENV WEB_ROOT=${PROJECT_DIR}/web
WORKDIR $PROJECT_DIR

# Use wrapper scripts for composer installed tools
ARG	WRAPPER_PATH=/usr/local/hacks/bin
ENV PATH=${PATH}:${WRAPPER_PATH}

# Allow using scripts from the composer packages
ENV PATH=${PATH}:${PROJECT_DIR}/vendor/bin

# Add few default variables
ENV \
	# This is the port that nginx uses
	PORT=8080 \
	
	# Default PHP settings
    PHP_MEMORY_LIMIT="128M" \
    PHP_MAX_INPUT_VARS="1000" \
    PHP_LOG_LEVEL="warning" \
    PHP_ERROR_LOG_MAX_LEN="8192" \
    PHP_SESSION_REDIS_DB="0" \
    PHP_SESSION_HANDLER="files" \
    # Amount of memory in MB to allocate for opcache
    PHP_OPCACHE_MAX_MEMORY="128" \
    PHP_OPCACHE_MAX_FILES="10000" \

    # Allow changing nginx timeout
    NGINX_FASTCGI_TIMEOUT="30"

COPY docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT /docker-entrypoint.sh

# Run forego	
CMD ["forego", "start"]

# Allow better caching and only update platform dependencies when composer.lock is changed
ONBUILD COPY composer.lock ${PROJECT_DIR}/
ONBUILD RUN build_platform_from_composer_lock

# Allow changing the timezone
ONBUILD ARG TZ="Europe/Helsinki"
ONBUILD ENV TZ=${TZ}
ONBUILD RUN ln -sf /usr/share/zoneinfo/$TZ /etc/localtime