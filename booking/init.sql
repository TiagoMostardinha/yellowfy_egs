--Init the booking database
ALTER USER 'root'@'localhost' IDENTIFIED WITH caching_sha2_password BY 'admin';
CREATE DATABASE IF NOT EXISTS booking;
CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON booking.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;