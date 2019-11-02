FROM logstash:6.4.2
COPY "./config/logstash.yml" "/usr/share/logstash/config/logstash.yml"
COPY "./config/pipelines.yml" "/usr/share/logstash/config/pipelines.yml"
COPY "./conf.d" "/usr/share/logstash/pipeline"
RUN set -e; \
    rm /usr/share/logstash/pipeline/logstash.conf; \
    mkdir -p /usr/share/logstash/logstash-output-amazon_es; \
    curl -L "https://api.github.com/repos/awslabs/logstash-output-amazon_es/tarball" | tar xvz --strip 1 -C logstash-output-amazon_es; \
    echo "gem \"logstash-output-amazon_es\", :path => \"/usr/share/logstash/logstash-output-amazon_es\"" >> /usr/share/logstash/Gemfile
