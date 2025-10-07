# td-agent の公式イメージをベースにする
FROM fluent/fluentd:v1.19.0-debian-2.1

USER root
# 必要なプラグインをインストール
# https://docs.fluentd.org/deployment/plugin-management
# RUN gem install fluent-plugin-datadog fluent-plugin-rewrite-tag-filter fluent-plugin-grok-parser
# RUN gem install fluent-plugin-datadog
RUN fluent-gem install fluent-plugin-datadog
RUN fluent-gem install fluent-plugin-multi-format-parser
# RUN fluent-gem install fluent-plugin-grok-parser
RUN fluent-gem install fluent-plugin-rewrite-tag-filter

# RUN buildDeps="sudo make gcc g++ libc-dev" \
#  && apt-get update \
#  && apt-get install -y --no-install-recommends $buildDeps \
#  && sudo gem install fluent-plugin-datadog fluent-plugin-rewrite-tag-filter \
#  && sudo gem sources --clear-all \
#  && SUDO_FORCE_REMOVE=yes \
#     apt-get purge -y --auto-remove \
#                   -o APT::AutoRemove::RecommendsImportant=false \
#                   $buildDeps \
#  && rm -rf /var/lib/apt/lists/* \
#  && rm -rf /tmp/* /var/tmp/* /usr/lib/ruby/gems/*/cache/*.gem

# COPY entrypoint.sh /bin/

# ENV FLUENTD_CONF="fluent.conf"

# デフォルトのユーザーに戻す
USER fluent 
