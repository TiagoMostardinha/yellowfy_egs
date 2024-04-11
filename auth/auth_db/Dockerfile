FROM mysql:latest
ENV MYSQL_DATABASE flask_app_db
COPY ./scripts/ /docker-entrypoint-initdb.d/
# Expose the MySQL port
EXPOSE 3306