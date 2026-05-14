#!/bin/bash

# データディレクトリが未初期化の場合、初期化する
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # 一時的にMariaDBを起動してDB・ユーザーを作成
    mysqld --user=mysql &
    MYSQL_PID=$!

    echo "Waiting for MariaDB to start..."
    for i in $(seq 1 30); do
        if mysqladmin ping --silent 2>/dev/null; then
            echo "MariaDB is ready."
            break
        fi
        sleep 1
    done

    mysql -u root <<EOSQL
CREATE DATABASE IF NOT EXISTS \`wordpress-db\`;
CREATE USER 'wordpress-user'@'10.10.10.12' IDENTIFIED BY 'wordpress-password';
FLUSH PRIVILEGES;
EOSQL

    echo "Database setup complete. Shutting down temporary instance..."
    mysqladmin shutdown
    wait $MYSQL_PID
fi

# systemctl 互換スクリプトに制御を渡す（PID 1 として動作）
exec /usr/bin/systemctl
