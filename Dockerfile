FROM python:3.10-slim

# Устанавливаем Nginx
RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем зависимости и устанавливаем их
COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копируем код приложения
COPY app/ .

# Копируем конфиг Nginx из папки nginx
COPY nginx/default.conf /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default && \
    ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Копируем скрипт запуска и даем права
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Открываем порт
EXPOSE 8080

CMD ["/start.sh"]