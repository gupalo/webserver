#!/usr/bin/env bash

while true; do
    echo 'cron: run';
    /usr/local/bin/php /code/cron.php;
    echo 'cron: sleep';
    sleep 3600;
done
