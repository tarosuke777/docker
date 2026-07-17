FROM eclipse-temurin:25

ENV DEBIAN_FRONTEND=noninteractive

# ビルド時に全部インストールを済ませてしまう
RUN apt-get update && \
    apt-get install -y git curl && \
    curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g @github/copilot @openai/codex && \
    curl -fsSL https://antigravity.google/cli/install.sh | bash

# agyへのパスを通す
RUN echo 'export PATH="/root/.local/bin:$PATH"' >> /root/.bashrc

WORKDIR /root
CMD ["bash"]