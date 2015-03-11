FROM hpess/golang
MAINTAINER Karl Stoney <karl.stoney@hp.com> 

# Download and Compile it
RUN cd /tmp && \
    https_proxy=http://proxy.sdc.hp.com:8080 wget https://github.com/elastic/logstash-forwarder/archive/v0.4.0.tar.gz && \
    tar -xvzf v0.4.0.tar.gz && \
    cd logstash-forwarder-* && \
    mkdir -p /opt/logstash-forwarder && \
    go build -o /opt/logstash-forwarder/logstash-forwarder && \
    rm -rf /tmp/logstash-* && \
    rm -rf /tmp/v0.4*

RUN  https_proxy=http://proxy.sdc.hp.com:8080 http_proxy=http://proxy.sdc.hp.com:8080 yum -y install openssl && \
     yum -y clean all

COPY storage/* /storage/
COPY tmp/* /tmp/
COPY preboot/* /preboot/
COPY services/* /etc/supervisord.d/

VOLUME ["/logs"]

ENV chef_node_name logstash-forwader.docker.local
