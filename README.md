# WordPress 3台構成 Docker環境

## 構成
- web (Apache)      : 10.10.10.11:80   → ホストの localhost:8080
- ap  (PHP-FPM)     : 10.10.10.12:8000
- db  (MariaDB)     : 10.10.10.13:3306

## 起動方法
```
cd wp-training
docker compose up -d --build
```

## 確認方法
ブラウザで http://localhost:8080 にアクセス

## コンテナに入る
```
docker exec -it web bash    # Webサーバー
docker exec -it ap bash     # APサーバー
docker exec -it db bash     # DBサーバー
```

## サービス再起動（コンテナの外から）
```
docker restart web
docker restart ap
docker restart db
```

## 環境の停止・削除
```
docker compose down
```

## 環境のリセット（最初からやり直し）
```
docker compose down
docker compose up -d --build
```
