#!/bin/bash
# setup.sh - Tối ưu hóa cho Cloud-init & Terraform

# Bật chế độ dừng script ngay lập tức nếu có lỗi nghiêm trọng ở các lệnh nền tảng
set -e

# 1. Thêm PPA để cài đặt PHP 8.2 và tắt các hộp thoại tương tác
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y software-properties-common curl unzip git netcat-openbsd
add-apt-repository -y ppa:ondrej/php
apt-get update -y

# Cài đặt Nginx và các gói PHP 8.2 cần thiết (Bổ sung php8.2-cli)
apt-get install -y nginx php8.2-fpm php8.2-cli php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip php8.2-bcmath

# Tắt set -e tạm thời cho các bước cấu hình linh hoạt bên dưới
set +e

# 1.5. Tạo SWAP 2GB (Chống sập trình duyệt/Composer do thiếu RAM trên VM nhỏ)
if [ ! -f /swapfile ]; then
    fallocate -l 2G /swapfile
    chmod 600 /swapfile
    mkswap /swapfile
    swapon /swapfile
    echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi

# 2. Cài đặt Composer chuẩn xác (Đã vá lỗi thiếu biến HOME trong cloud-init)
echo "Đang tải và cài đặt Composer..."

# Tạo thư mục cache cho root nếu chưa có và gán biến môi trường trực tiếp
mkdir -p /root/.composer
export COMPOSER_HOME="/root/.composer"

curl -sS https://getcomposer.org/installer -o composer-setup.php
php8.2 composer-setup.php --install-dir=/usr/local/bin --filename=composer
rm composer-setup.php

# Đảm bảo file Composer có quyền thực thi và kiểm tra trạng thái
chmod +x /usr/local/bin/composer
/usr/local/bin/composer --version || { echo "Lỗi: Không thể cài đặt Composer!"; exit 1; }

# 3. Cài đặt Tailscale và Join mạng
curl -fsSL https://tailscale.com/install.sh | sh
tailscale up --authkey=${TS_KEY} --hostname=web-server --ssh --accept-dns=true

# 4. Cấu hình SSH Deploy Key để Clone Code bảo mật
mkdir -p /root/.ssh
echo "${SSH_PRIVATE_KEY}" > /root/.ssh/id_rsa
chmod 600 /root/.ssh/id_rsa
ssh-keyscan github.com >> /root/.ssh/known_hosts

# 5. Clone Code Laravel
mkdir -p /home/ubuntu/app
# Xóa thư mục nếu đã tồn tại để tránh lỗi khi re-run script
rm -rf /home/ubuntu/app/* /home/ubuntu/app/.* 2>/dev/null || true
git clone git@github.com:ThongVu1996/terraform-hybrid-lab-laravel-code.git /home/ubuntu/app
chown -R ubuntu:ubuntu /home/ubuntu/app

# 6. Cấu hình Laravel
echo "Đang cấu hình Laravel..."
cd /home/ubuntu/app

# 6.1. Cài đặt dependencies bằng Composer
sudo -u ubuntu php8.2 /usr/local/bin/composer install --no-interaction --optimize-autoloader --no-scripts || { echo "Composer failed"; exit 1; }

# 6.2. Cấu hình file .env
sudo -u ubuntu cp .env.example .env
sudo -u ubuntu sed -i "s/DB_CONNECTION=sqlite/DB_CONNECTION=mysql/" .env
sudo -u ubuntu sed -i "s/# DB_HOST=127.0.0.1/DB_HOST=db-server/" .env
sudo -u ubuntu sed -i "s/# DB_PORT=3306/DB_PORT=3306/" .env
sudo -u ubuntu sed -i "s/# DB_DATABASE=laravel/DB_DATABASE=${DB_NAME}/" .env
sudo -u ubuntu sed -i "s/# DB_USERNAME=root/DB_USERNAME=${DB_USER}/" .env
sudo -u ubuntu sed -i "s/# DB_PASSWORD=/DB_PASSWORD=${DB_PASS}/" .env
sudo -u ubuntu sed -i 's/^# DB_/DB_/g' .env

# Generate App Key
sudo -u ubuntu php8.2 artisan key:generate

# 6.3. Phân quyền chuẩn cho Web Server (Nginx chạy dưới quyền www-data)
chown -R www-data:www-data /home/ubuntu/app/storage /home/ubuntu/app/bootstrap/cache
chmod -R 775 /home/ubuntu/app/storage /home/ubuntu/app/bootstrap/cache
# Cấp quyền cho user www-data có thể đọc qua thư mục home của ubuntu
chmod o+x /home/ubuntu

# 7. Cấu hình Nginx
cat <<EOF > /etc/nginx/sites-available/laravel
server {
    listen 80;
    server_name _;
    root /home/ubuntu/app/public;

    add_header X-Frame-Options "SAMEORIGIN";
    add_header X-Content-Type-Options "nosniff";

    index index.php;
    charset utf-8;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    error_page 404 /index.php;

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~ /\.(?!well-known).* {
        deny all;
    }
}
EOF

ln -sf /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

# 8. Khởi động lại các dịch vụ và cho phép chạy cùng hệ thống
systemctl enable --now php8.2-fpm
systemctl enable --now nginx
systemctl restart nginx

# 9. Chờ đợi máy DB online qua mạng Tailscale
echo "Đang chờ kết nối đến máy Database trên Proxmox..."
# Đảm bảo Tailscale DNS đã nhận diện được db-server
until nc -zv db-server 3306; do
  echo "Máy DB chưa sẵn sàng, đang thử lại sau 5 giây..."
  sleep 5
done
echo "KẾT NỐI DB THÀNH CÔNG! Bắt đầu chạy Migration..."

# 10. Chạy Migration
sudo -u ubuntu php8.2 artisan migrate --force

echo "TRIỂN KHAI HOÀN TẤT!"