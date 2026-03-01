# Jenkins アップデート・バックアップ手順

## 1. 本体アップデート手順
以下のコマンドを順番に実行し、ベースイメージの更新とコンテナの再構築を行います。

### ① 最新ベースイメージを強制的にダウンロード
docker pull jenkins/jenkins:lts

### ② Dockerfileに基づき、新しいイメージをビルド
docker compose build --no-cache

### ③ コンテナを停止・削除し、新しいイメージで起動
docker compose up -d

---

## 2. 設定のバックアップ
Jenkins内のデータ保護のため、以下のツールを使用してバックアップを管理します。

### 使用ツール
* **ThinBackup** (Jenkinsプラグイン)
