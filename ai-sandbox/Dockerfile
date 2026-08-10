FROM eclipse-temurin:25

ENV DEBIAN_FRONTEND=noninteractive

# ビルド時に全部インストールを済ませてしまう
# ビルド時に全部インストールを済ませてしまう
RUN apt-get update && \
    apt-get install -y git curl wget gnupg tar && \
    # Node.js リポジトリのセットアップ
    curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    # GitHub CLI (gh) リポジトリのセットアップ
    mkdir -p /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    # Node.js と gh のインストール
    apt-get update && \
    apt-get install -y nodejs gh && \
    # npm パッケージのインストール
    npm install -g @github/copilot @openai/codex && \
    # antigravity CLI のインストール
    curl -fsSL https://antigravity.google/cli/install.sh | bash

# 最新のGoを落として /usr/local に展開
RUN GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1) && \
    curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz

# Goおよびagyへのパスを通す (PATH環境変数を直接設定するのがおすすめ)
ENV PATH="/usr/local/go/bin:/root/.local/bin:${PATH}"

# ブラウザ本体 と 構成に必要な依存パッケージを追加
RUN npx playwright install --with-deps && \
    # 最後にまとめてaptのキャッシュを削除
    rm -rf /var/lib/apt/lists/*

WORKDIR /root
CMD ["bash"]