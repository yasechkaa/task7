#!/bin/bash
# Запуск gunicorn с явным указанием прав на сокет 0666
gunicorn --bind unix:/tmp/app.sock -m 0666 --workers 2 wsgi:app --daemon

# Запуск nginx
nginx -g "daemon off;"