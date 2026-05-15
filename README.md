# WordPress 3台構成 トラブルシューティング研修

## 概要

意図的にエラーが仕込まれた WordPress 環境を起動し、エラーハンドリングを行って WordPress をブラウザで表示できるようにする研修です。

## 構成

| サーバ | コンテナ名 | IP | ポート | ミドルウェア |
|--------|-----------|-----|--------|-------------|
| Web | web | 10.10.10.11 | 80 (ホスト:8080) | Apache |
| AP | ap | 10.10.10.12 | 8000 | PHP-FPM |
| DB | db | 10.10.10.13 | 3306 | MariaDB |

## 問題一覧

| 問題 | ブランチ | エラー内容 | 対象サーバ |
|------|---------|-----------|-----------|
| 問1 | `lv1-q1` | Apache（httpd）が自動起動しない | Web |
| 問2 | `lv1-q2` | php.conf のプロキシポートが 9000（正: 8000） | Web |
| 問3 | `lv1-q3` | wp-config.php の DB名が違う＋セミコロン欠落 | AP |
| 問4 | `lv1-q4` | php.conf に Require all denied が追加されている | Web |
| 問5 | `lv1-q5` | php.conf の timeout が 1秒（正: 30秒） | Web |
| 問6 | `lv1-q6` | MariaDB の bind-address が 127.0.0.1（正: 0.0.0.0） | DB |
| 問7 | `lv1-q7` | wp-config.php のパーミッションが 000 | AP |
| 問8 | `lv1-q8` | wp-config.php の DB_HOST が 10.10.10.99（正: 10.10.10.13） | AP |
| 問9 | `lv1-q9` | PHP-FPM の allowed_clients が 10.10.10.99（正: 10.10.10.11） | AP |
| 問10 | `lv1-q10` | DB ユーザーに GRANT 権限がない（CREATE USER のみ） | DB |

## インスタンスの準備
①起動テンプレートからインスタンスを起動
②"アプリケーション"及びOSイメージ欄から、自分のAMI→自己所有→Amazonマシンイメージから"Wordpress"を選択
　キーペア、セキュリティグループは各自研修で使用している物を選択し、リソースタグから名前を付けてインスタンスを起動。
③サーバへSSH接続を行い、エラーハンドリングに取り組む。 

## 問題の進め方

### 1. ブランチを切り替える

作成したインスタンスにSSH後

```bash
cd Wordpress-training
git branch -a　　　　　　※問題が１～１０まであることを確認(lv1-q1~10)
git checkout lv1-q1
```

### 2. コンテナを1台ずつ起動する

```bash
docker compose up -d --build db
docker compose up -d --build ap
docker compose up -d --build web
```

### 3. ブラウザで症状を確認する

```
http://localhost:8080
```

→ エラーが表示される（503, 500, 403, 接続拒否 など）

### 4. 各サーバに入ってエラーハンドリング

```bash
# Web サーバに入る
docker exec -it web bash

# AP サーバに入る
docker exec -it ap bash

# DB サーバに入る
docker exec -it db bash

# サーバから出る
exit
```

### 5. WordPress が表示されたら正解！

### 6. 次の問題に移る

```bash
# 現在の環境を停止・削除
docker compose down

# 次の問題のブランチに切り替え
git checkout lv1-q2

# コンテナを1台ずつ起動
docker compose up -d --build db
docker compose up -d --build ap
docker compose up -d --build web
```

以降、同じ流れを繰り返します。

## よく使うコマンド

| 目的 | コマンド |
|------|---------|
| サービス状態確認 | `systemctl status httpd / php-fpm / mariadb` |
| プロセス確認 | `ps aux \| grep httpd` |
| ポート確認 | `ss -tlnp \| grep ポート番号` |
| Apache エラーログ | `tail -20 /var/log/httpd/error_log` |
| Apache 設定チェック | `httpd -t` |
| PHP 構文チェック | `php -l ファイル名` |
| DB 接続テスト | `mysql -u wordpress-user -h 10.10.10.13 -p wordpress-db` |
| ファイル権限確認 | `ls -la /var/www/html/wp-config.php` |
| サービス起動 | `systemctl start httpd` |
| サービス再起動 | `systemctl restart httpd` |

## コンテナの外からの操作

```bash
# コンテナの再起動（中に入らずに）
docker restart web
docker restart ap
docker restart db

# 環境の完全リセット（最初からやり直し）
docker compose down
docker compose up -d --build db
docker compose up -d --build ap
docker compose up -d --build web
```
