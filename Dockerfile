FROM wordpress

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
  && chmod +x wp-cli.phar \
  && mv wp-cli.phar /usr/local/bin/wp

# Set the max upload size.
RUN { \
    echo 'upload_max_filesize = 32M'; \
    echo 'post_max_size = 32M'; \
  } > /usr/local/etc/php/conf.d/upload-filesize.ini

# Optomize container for a low-memory VPS.
RUN { \
    echo 'StartServers 1'; \
    echo 'MinSpareServers 1'; \
  } | tee "$APACHE_CONFDIR/conf-available/low-memory.conf" \
  && a2enconf low-memory

RUN a2enmod env
