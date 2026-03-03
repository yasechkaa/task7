#!/bin/bash
# Настройки из твоего docker inspect
DB_USER="user" 
CONTAINER="task6_db_1"
DB="crud_db"

echo "=== ЗАПУСК МОНИТОРИНГА: ПОЛЬЗОВАТЕЛЬ $DB_USER ==="
echo "Сейчас графики в Grafana пойдут вверх..."

while true
do
  # 1. Делаем реальное действие в базе (создаем и удаляем таблицу)
  # Это гарантирует рост 'Интенсивности работы' (rate)
  docker exec -t $CONTAINER psql -U $DB_USER -d $DB -c "
    CREATE TEMP TABLE load_test AS SELECT generate_series(1,100);
    DROP TABLE load_test;
  " > /dev/null &

  # 2. Оставляем одно соединение 'висеть' на секунду
  # Это гарантирует рост 'Активных подключений'
  docker exec -t $CONTAINER psql -U $DB_USER -d $DB -c "SELECT pg_sleep(1);" > /dev/null &

  echo "Транзакция успешно отправлена в $(date +%H:%M:%S)"
  
  # Пауза между волнами
  sleep 0.5
done