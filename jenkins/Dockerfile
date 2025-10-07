# Jenkins公式イメージをベースにする
FROM jenkins/jenkins:lts

# Jenkinsコンテナ内でDockerとDocker Composeをインストール
USER root
RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release sudo

# Docker公式GPG鍵を追加
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Dockerリポジトリを追加
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Docker CLIとDocker Composeをインストール
RUN apt-get update && \
    apt-get install -y docker-ce-cli docker-compose-plugin 

# ここで docker グループが作成されているか確認し、Jenkins ユーザーを追加
RUN if ! getent group docker > /dev/null; then \
        groupadd --gid 999 docker; \
    fi && \
    usermod -aG docker jenkins

# sudoersファイルを作成し、パスワードなしでsudoers権限を許可
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins && \
    chmod 0440 /etc/sudoers.d/jenkins

# Jenkinsユーザーに戻る
USER jenkins