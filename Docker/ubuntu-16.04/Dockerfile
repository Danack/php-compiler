FROM ircmaxell/php-compiler:16.04-dev

COPY ./ /compiler

WORKDIR /compiler

RUN php /composer.phar install --no-ansi --no-dev --no-interaction --no-progress --no-scripts --optimize-autoloader

# Needed to initialize PRE
RUN php vendor/autoload.php

# ENTRYPOINT ["php", "/compiler/bin/jit.php"]

CMD tail -f README.md

# CMD ["-r", "'echo \"Hello World\n\";'"]