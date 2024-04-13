CREATE DATABASE IF NOT EXISTS flask_app_db;


ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'root';
CREATE USER 'yellowfy'@'localhost' IDENTIFIED BY 'yellowfy';
GRANT ALL PRIVILEGES ON flask_app_db.* TO 'yellowfy'@'localhost';
FLUSH PRIVILEGES;
    