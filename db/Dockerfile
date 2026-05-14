FROM amazonlinux:2023

# 必要パッケージのインストール
RUN dnf update -y && \
    dnf install -y mariadb105-server \
    wget python3 \
    vim-minimal procps-ng iproute less && \
    dnf clean all

# systemctl 互換スクリプトの導入（※ dnf の後に配置すること）
RUN wget -q https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py \
    -O /usr/bin/systemctl && \
    chmod +x /usr/bin/systemctl

# bind-address を 127.0.0.1 に設定（localhost のみ待ち受け）
RUN echo -e "[mysqld]\nbind-address = 127.0.0.1" > /etc/my.cnf.d/docker.cnf

# mariadb を自動起動に設定
RUN systemctl enable mariadb

# エントリポイントスクリプトを配置
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

CMD ["/entrypoint.sh"]
