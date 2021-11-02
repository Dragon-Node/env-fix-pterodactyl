echo 'Deleting Database.....'
mariadb -e "drop database panel"; 
clear
echo 'Making Database.....'
mariadb -e "create database panel"; 
clear
echo 'Set database to user....'
mariadb -e "GRANT ALL PRIVILEGES ON panel.* TO 'pterodactyl'@'127.0.0.1' WITH GRANT OPTION"; 
clear
echo "Changing .env"
cd /var/www/pterodactyl
rm .env.example
rm .env
wget https://raw.githubusercontent.com/pterodactyl/panel/release/v1.6.3/.env.example
cp .env.example .env
composer install --no-dev --optimize-autoloader
php artisan key:generate --force
echo "fill the asked forms"
php artisan p:environment:setup
echo "fill the asked forms for setup the database"
php artisan p:environment:database
php artisan migrate --seed --force
echo "fill the asked forms for making a user"
php artisan p:user:make
clear
echo 'Done! We are finishing the script'
chown -R www-data:www-data /var/www/pterodactyl/*
sudo systemctl enable --now redis-server
pause
