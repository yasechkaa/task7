#!/bin/bash
# Запускаем Gunicorn в фоне, привязываем к unix-сокету с правами 0666
gunicorn --bind unix:/tmp/app.sock -m 0666 --workers 2 --threads 2 wsgi:app --daemon

# Запускаем Nginx на переднем плане
nginx -g "daemon off;"