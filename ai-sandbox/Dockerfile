FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

# 基本的なパッケージのインストール
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    wget \
    gnupg \
    tar && \
    rm -rf /var/lib/apt/lists/*

# --- Ruby / rbenv のビルド依存パッケージ ＆ MySQLクライアントライブラリのインストール ---
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libssl-dev \
    libreadline-dev \
    zlib1g-dev \
    libyaml-dev \
    libffi-dev \
    libgmp-dev \
    libdb-dev \
    libmariadb-dev && \
    rm -rf /var/lib/apt/lists/*

# --- PHP / phpenv のビルド依存パッケージのインストール ---
RUN apt-get update && \
    apt-get install -y \
    libssl-dev \
    libxml2-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    libcurl4-openssl-dev \
    libpng-dev \
    libjpeg-dev \
    libonig-dev \
    libzip-dev \
    libicu-dev \
    libtidy-dev \
    libxslt1-dev \
    pkg-config \
    autoconf \
    bison \
    re2c && \
    rm -rf /var/lib/apt/lists/*

# OpenJDK 25 のインストール
RUN apt-get update && \
    apt-get install -y openjdk-25-jdk && \
    rm -rf /var/lib/apt/lists/*

# Node.js リポジトリのセットアップとインストール
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get update && \
    apt-get install -y nodejs && \
    rm -rf /var/lib/apt/lists/*

# GitHub CLI (gh) のリポジトリ追加とインストール
RUN mkdir -p /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh && \
    rm -rf /var/lib/apt/lists/*

# グローバルなnpmパッケージのインストール
RUN npm install -g @github/copilot

# グローバルなnpmパッケージのインストール
RUN npm install -g @openai/codex

# antigravity CLI のインストール
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash

# 最新のGoのダウンロードと /usr/local への展開
RUN GO_VERSION=$(curl -s https://go.dev/VERSION?m=text | head -n 1) && \
    curl -fsSL "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz

# --- rbenv & Ruby 3.4.5 & Bundler 2.7.1 のセットアップ ---
ENV RBENV_ROOT="/usr/local/rbenv"
RUN git clone https://github.com/rbenv/rbenv.git "$RBENV_ROOT" && \
    git clone https://github.com/rbenv/ruby-build.git "$RBENV_ROOT/plugins/ruby-build" && \
    "$RBENV_ROOT/plugins/ruby-build/install.sh"

# Go、rbenv、およびagyへのパスを通す
ENV PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/go/bin:/root/.local/bin:${PATH}"

# 指定の Ruby 3.4.5 をビルド＆グローバル設定し、Bundler 2.7.1 を導入
RUN rbenv install 3.4.5 && \
    rbenv global 3.4.5 && \
    gem install bundler -v '2.7.1'

# --- phpenv & php-build & PHP 8.2 & Composer のセットアップ ---
ENV PHPENV_ROOT="/usr/local/phpenv"
RUN git clone https://github.com/phpenv/phpenv.git "$PHPENV_ROOT" && \
    git clone https://github.com/php-build/php-build.git "$PHPENV_ROOT/plugins/php-build"

# phpenv にパスを通す
ENV PATH="$PHPENV_ROOT/bin:$PHPENV_ROOT/shims:${PATH}"

# phpenv の初期化設定をシェルに追加（コンテナ内での実行用）
RUN echo 'export PHPENV_ROOT="/usr/local/phpenv"' >> /root/.bashrc && \
    echo 'export PATH="$PHPENV_ROOT/bin:$PHPENV_ROOT/shims:$PATH"' >> /root/.bashrc && \
    echo 'eval "$(phpenv init -)"' >> /root/.bashrc

# PHP 8.2.20 のビルド＆グローバル設定
RUN phpenv install 8.5.0 && \
    phpenv global 8.5.0 && \
    phpenv rehash

# --- Composer の公式インストーラー経由でのインストール ---
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === 'c8b085408188070d5f52bcfe4ecfbee5f727afa458b2573b8eaaf77b3419b0bf2768dc67c86944da1544f06fa544fd47') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }" && \
    php composer-setup.php --install-dir=/usr/local/bin --filename=composer && \
    php -r "unlink('composer-setup.php');"

# Playwright (ブラウザ本体と依存パッケージ) のインストール
RUN npx playwright install --with-deps

WORKDIR /root
CMD ["bash"]