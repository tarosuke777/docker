## AdGuard Home ユーザー名・パスワードリセット手順

公式ドキュメントに準拠し、WSL (Ubuntu) 上の `htpasswd` コマンドで bcrypt ハッシュを生成して設定ファイルを書き換えます。

### 1. WSL (Ubuntu) でパスワードハッシュを生成

コマンドプロンプト (cmd) から WSL (Ubuntu) にルート権限で入ります。

```cmd
wsl -d Ubuntu -u root
```

`htpasswd` コマンドが入っていない場合はインストールします。

```bash
apt update && apt install -y apache2-utils
```

以下のコマンドでハッシュを生成します（`<USERNAME>` と `<PASSWORD>` は適宜変更してください）。

```bash
htpasswd -B -C 10 -n -b <USERNAME> <PASSWORD>
```

* ※ 出力結果（例: `username:$2y$10$...`）の **`:`（コロン）より後ろの文字列**（`$2y$10$...`）をコピーしておきます。

### 2. 設定ファイルの編集（コンテナ内から操作）

AdGuard Home コンテナに入り、`AdGuardHome.yaml` を直接書き換えます。

```bash
# 1. コンテナへ入る
docker exec -it adguardhome sh

# 2. 設定ファイルのディレクトリへ移動
cd /opt/adguardhome/conf/

# 3. エディタで設定ファイルを開く
vi AdGuardHome.yaml
```

`users` セクションを探し、ユーザー名と手順1で取得したハッシュ値を設定します。

```yaml
users:
  - name: <USERNAME>
    password: "$2y$10$..." # ← 手順1で取得したハッシュ値
```

> **`vi` の簡易操作メモ:**
> * 編集開始: `i` キーを押す
> * 保存して終了: `Esc` キーを押す -> `:wq` と入力して `Enter`
> * 保存せずに終了: `Esc` キーを押す -> `:q!` と入力して `Enter`

コンテナの編集が終わったら、`exit` でコンテナから抜けます。

```bash
exit
```

### 3. コンテナの再起動

変更を反映させるために AdGuard Home コンテナを再起動します。

```bash
docker compose restart adguardhome
```