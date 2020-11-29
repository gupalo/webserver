#!/usr/bin/env bash

/usr/local/bin/php /code/init.php

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
