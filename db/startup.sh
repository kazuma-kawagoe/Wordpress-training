#!/bin/bash

# データディレクトリが未初期化の場合、初期化する
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# MariaDB をバックグラウンドで起動
mysqld --user=mysql &
MYSQL_PID=$!

# MariaDB の起動を待つ
echo "Waiting for MariaDB to start..."
for i in $(seq 1 30); do
    if mysqladmin ping --silent 2>/dev/null; then
        echo "MariaDB is ready."
        break
    fi
    sleep 1
done

# データベースとユーザーの作成
mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`wordpress-db\`;
GRANT ALL PRIVILEGES ON \`wordpress-db\`.* TO 'wordpress-user'@'10.10.10.12' IDENTIFIED BY 'wordpress-password';
FLUSH PRIVILEGES;
EOF

echo "Database setup complete."

# フォアグラウンドで待機
wait $MYSQL_PID
