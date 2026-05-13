FROM amazonlinux:2023

# 必要パッケージのインストール
RUN dnf update -y --allowerasing && \
    dnf install -y mariadb105-server \
    vim-minimal procps-ng iproute less \
    systemd && \
    dnf clean all

# bind-address を 0.0.0.0 に設定
RUN echo -e "[mysqld]\nbind-address = 0.0.0.0" > /etc/my.cnf.d/docker.cnf

# 起動スクリプトを配置
COPY startup.sh /startup.sh
RUN chmod +x /startup.sh

# mariadbを自動起動に設定
RUN systemctl enable mariadb

CMD ["/sbin/init"]
