FROM amazonlinux:2023

# 必要パッケージのインストール
RUN dnf update -y --allowerasing && \
    dnf install -y httpd wget tar gzip \
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

# デフォルトのウェルカムページを削除
RUN rm -f /etc/httpd/conf.d/welcome.conf

# php.conf を配置（proxy:fcgi 設定）
COPY php.conf /etc/httpd/conf.d/php.conf

RUN echo 'PS1="[\u@web \W]\$ "' >> /root/.bashrc

EXPOSE 80
CMD ["/usr/bin/systemctl"]
