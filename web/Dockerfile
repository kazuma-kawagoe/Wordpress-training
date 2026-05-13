FROM amazonlinux:2023

# 必要パッケージのインストール
RUN dnf update -y --allowerasing && \
    dnf install -y httpd wget tar gzip \
    vim-minimal procps-ng iproute less \
    systemd && \
    dnf clean all

# WordPressのダウンロードと配置
RUN cd /tmp && \
    wget -q https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    cp -r wordpress/* /var/www/html/ && \
    rm -rf latest.tar.gz wordpress

# デフォルトのウェルカムページを削除
RUN rm -f /etc/httpd/conf.d/welcome.conf

# php.conf を配置
COPY php.conf /etc/httpd/conf.d/php.conf

# httpdの自動起動を無効化（問1のエラー）
RUN systemctl disable httpd

CMD ["/sbin/init"]
