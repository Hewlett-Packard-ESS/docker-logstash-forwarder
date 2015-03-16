FROM hpess/golang:master
MAINTAINER Karl Stoney <karl.stoney@hp.com> 

# Download and Compile it
RUN cd /tmp && \
    wget --quiet https://github.com/elastic/logstash-forwarder/archive/v0.4.0.tar.gz && \
    tar -xzf v0.4.0.tar.gz && \
    cd logstash-forwarder-* && \
    mkdir -p /opt/logstash-forwarder && \
    go build -o /opt/logstash-forwarder/logstash-forwarder && \
    rm -rf /tmp/logstash-* && \
    rm -rf /tmp/v0.4*

RUN  yum -y install openssl && \
     yum -y clean all

COPY tmp/* /tmp/
COPY preboot/* /preboot/
COPY services/* /etc/supervisord.d/

WORKDIR /opt/logstash-forwarder
ENV HPESS_ENV logstash-forwarder
 
VOLUME ["/logs"]
ENV chef_node_name logstash-forwader.docker.local
