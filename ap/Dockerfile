FROM amazonlinux:2023

# 必要パッケージのインストール
RUN dnf update -y --allowerasing && \
    dnf install -y php-fpm php-mysqli php-json php-devel \
    wget tar gzip \
    python3 \
    vim-minimal procps-ng iproute less && \
    dnf clean all

# systemctl 互換スクリプトの導入（※ dnf の後に配置すること）
RUN wget -q https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py \
    -O /usr/bin/systemctl && \
    chmod +x /usr/bin/systemctl

# WordPressのダウンロードと配置
RUN cd /tmp && \
    wget -q https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    cp -r wordpress/* /var/www/html/ && \
    rm -rf latest.tar.gz wordpress

# wp-config.php を配置
COPY wp-config.php /var/www/html/wp-config.php

# 所有者をapacheに変更
RUN chown -R apache:apache /var/www/html/

# PHP-FPM用ディレクトリを作成
RUN mkdir -p /run/php-fpm

# www.conf を修正（listen アドレスとアクセス許可）
RUN sed -i 's|^listen = /run/php-fpm/www.sock|listen = 0.0.0.0:8000|' /etc/php-fpm.d/www.conf && \
    sed -i 's|^listen.allowed_clients = 127.0.0.1|;listen.allowed_clients = 127.0.0.1|' /etc/php-fpm.d/www.conf && \
    echo "listen.allowed_clients = 10.10.10.11" >> /etc/php-fpm.d/www.conf

# php-fpm を自動起動に設定
RUN systemctl enable php-fpm

EXPOSE 8000

CMD ["/usr/bin/systemctl"]
