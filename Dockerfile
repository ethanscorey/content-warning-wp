# Modifies WP image to add PHPUnit
# Based on https://marioyepes.com/wordpress-plugin-tdd-with-docker-phpunit/
FROM wordpress:latest

ARG PLUGIN_NAME=modals-wp

# Setup the OS
RUN apt-get -qq update ; apt-get -y install wget unzip curl sudo subversion mariadb-client \
&& apt-get autoclean \
&& chsh -s /bin/bash www-data


# Install wp-cli
RUN curl https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /usr/local/bin/wp-cli.phar \
        && echo "#!/bin/bash" > /usr/local/bin/wp-cli \
        && echo "su www-data -c \"/usr/local/bin/wp-cli.phar --path=/var/www/html \$*\"" >> /usr/local/bin/wp-cli \
        && chmod 755 /usr/local/bin/wp-cli* \
        && echo "*** wp-cli command installed"

# Install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
        && php composer-setup.php \
        && php -r "unlink('composer-setup.php');" \
        && mv composer.phar /usr/local/bin \
        && echo '#!/bin/bash' > /usr/local/bin/composer \
        && echo "su www-data -c \"/usr/local/bin/composer.phar --working-dir=/var/www/html/wp-content/plugins/${PLUGIN_NAME} \$*\"" >> /usr/local/bin/composer \
        && chmod ugo+x /usr/local/bin/composer \
        && echo "*** composer command installed"

#COPY --chmod=755 modals-wp/bin/install-wp-tests.sh /usr/local/bin/
#RUN echo "#!/bin/bash" > /usr/local/bin/install-wp-tests \
#        && echo "su www-data -c \"install-wp-tests.sh \${WORDPRESS_DB_NAME}_test root password \${WORDPRESS_DB_HOST} latest\"" >> /usr/local/bin/install-wp-tests \
#        && chmod ugo+x /usr/local/bin/install-wp-test* \
#        && su www-data -c "/usr/local/bin/install-wp-tests.sh ${WORDPRESS_DB_NAME}_test root password '' latest true" \
#        && echo "*** install-wp-tests installed"
