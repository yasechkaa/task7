Grafana	http://localhost:3000	Твои 2-3 «годных» дашборда: мониторинг ресурсов, БД и веб-трафика.
Prometheus	http://localhost:9090	Консоль для выполнения сырых запросов (PromQL).
Статус таргетов	http://localhost:9090/targets	Доказательство, что Prometheus видит все твои контейнеры (app, db, nginx) и они в статусе UP.
Метрики Nginx	http://localhost:9913/metrics	Сырые данные от VTS-экспортера (коды ответов, latency). 
Твоё приложение	http://localhost/users	Работающий фронтенд, через который ты будешь создавать нагрузку. 