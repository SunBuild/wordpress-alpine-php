#
# Dockerfile for WordPress
#
FROM appsvcorg/alpine-php-mysql:0.1 
MAINTAINER Azure App Service Container Images <appsvc-images@microsoft.com>

# ========
# ENV vars
# ========

# wordpress
ENV WORDPRESS_SOURCE "/var/www"
ENV WORDPRESS_HOME "/var/www"
ENV GIT_REPO=https://github.com/azureappserviceoss/wordpress-azure.git 

#
ENV DOCKER_BUILD_HOME "/dockerbuild"

# ====================
# Download and Install
# ~. tools
# 1. redis
# 2. wordpress
# ====================

WORKDIR $DOCKER_BUILD_HOME
RUN set -ex \
	# --------
	# 1. redis
	# --------
        && apk add --update redis \
	# ------------	
	# 2. wordpress
	# ------------
	&& apk add --update git \
        # cp in final
	# ----------
	# ~. clean up
	# ----------
	&& rm -rf /var/cache/apk/* 

# =========
# Configure
# =========
# httpd confs
COPY httpd-wordpress.conf $HTTPD_CONF_DIR/

RUN set -ex \
	##
	&& ln -s $WORDPRESS_HOME /var/www/wordpress \
    ##
    && test -e /usr/local/bin/entrypoint.sh && mv /usr/local/bin/entrypoint.sh /usr/local/bin/entrypoint.bak
	
# =====
# final
# =====
COPY wp-config.php $WORDPRESS_HOME/

COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 2222 80
ENTRYPOINT ["entrypoint.sh"]
