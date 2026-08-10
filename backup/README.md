# 📦 バックアップデータ（.tar.gz）からの復元手順書

独立して動かしているAlpineコンテナ（`backup_loop`）が自動生成したバックアップアーカイブ（`.tar.gz`）から、GrafanaおよびLokiのデータを完全に復元（リストア）するための手順書です。

データの一貫性と安全性を確保するため、復元作業は必ず本体サービスおよびバックアップコンテナを一時停止した状態で行ってください。

---

## 📋 前提条件
* バックアップファイル（例: `grafana_20260630_120000.tar.gz` や `loki_20260630_120000.tar.gz`）が `C:\dev\backups` フォルダに存在していること。
* 復元対象となるDockerボリューム（`grafana_grafana-storage`、`grafana_loki-storage`）が存在していること。

---

## 🛠️ 復元ステップ

### ステップ1: 運用中（Grafana / Loki）コンテナの停止
データ書き込み中の破損や競合を防ぐため、ログ収集・可視化を行っているメインのDocker Compose（GrafanaやLokiが動いている側）を停止します。

メインの `docker-compose.yml` があるディレクトリに移動し、以下のコマンドを実行します。
```bash
docker compose down
```

### ステップ2: バックアップ専用コンテナ（backup_loop）の停止
独立して動かしているバックアップ用のコンテナも、処理の競合を避けるため一時的に停止します。

バックアップ用 `docker-compose.yml` があるディレクトリ（`C:\dev\docker\backup` など）に移動し、以下のコマンドを実行します。
```bash
docker compose down
```

### ステップ3: データの復元（リストア）の実行
コマンドプロンプトまたはPowerShellを開き、以下のコマンドを順に実行します。
> ⚠️ **重要:** ファイル名に含まれる日時部分（`_20260630_120000`）は、**実際に復元したいバックアップファイルの名前に合わせて必ず書き換えてください**。

#### ① Grafanaのデータ復元
```powershell
docker run --rm -v C:\dev\backups:/archive -v grafana_grafana-storage:/data alpine sh -c "rm -rf /data/* && tar xzf /archive/grafana_20260630_120000.tar.gz -C /data"
```

#### ② Lokiのデータ復元
```powershell
docker run --rm -v C:\dev\backups:/archive -v grafana_loki-storage:/data alpine sh -c "rm -rf /data/* && tar xzf /archive/loki_20260630_120000.tar.gz -C /data"
```

```powershell
docker run --rm -v C:\dev\backups:/archive -v jenkins_jenkins_data:/data alpine sh -c "rm -rf /data/* && tar xzf /archive/jenkins_20260630_120000.tar.gz -C /data"
```

#### 💡 コマンドの内部挙動
1. 公式の軽量Linuxイメージである `alpine` コンテナを一時的に使い捨て起動します。
2. 既存のターゲットボリューム内を一度クリーンアップします（`rm -rf /data/*`）。
3. 指定したホスト側の `.tar.gz` バックアップアーカイブをボリューム内に展開します（`tar xzf`）。
4. 処理が完了すると、一時コンテナは自動的に消去されます（`--rm`）。

### ステップ4: サービスの再開
復元が完了したら、各サービスを順番に再起動します。

#### ① メインサービス（Grafana / Loki）の起動
メインのディレクトリに移動し、コンテナを通常通りバックグラウンド起動します。
```bash
docker compose up -d
```
起動完了後、ブラウザから `http://localhost/grafana/` にアクセスし、ダッシュボードや過去のアラート設定、ログデータが指定した過去の時点の状態に正しく巻き戻っているか確認してください。

#### ② 定期バックアップの再開
バックアップ用のディレクトリに戻り、定期バックアップコンテナの常駐処理を再開させます。
```bash
docker compose up -d
```

---

## 🚨 注意事項
* **データの完全上書き:** 本手順を実行すると、現在のターゲットボリューム内にある最新データはすべて破棄され、バックアップ時点の状態に完全に上書きされます。現在の最新状態を念のため残したい場合は、作業前に手動で別名退避するなどの対策をとってください。
* **ボリューム名の不一致:** 万が一「ボリュームが見つからない」という旨のエラーが出た場合は、`docker volume ls` コマンドで実際のボリューム名（プレフィックス等）を確認し、コマンド内の引数を適切に修正してください。
