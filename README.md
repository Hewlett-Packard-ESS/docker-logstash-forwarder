## hpess/logstash-forwarder
This container is a docker implementation of [Logstash Forwarder](https://github.com/elastic/logstash-forwarder) for sending file based logs to a central logstash server in a secure and fast way.

## Use
We use these as "connectors" basically, to shit data from different areas.  You can run it out of the box with just a few environment variables!

An example docker-compose file:
```
logstashfw:
  image: hpess/logstash-forwarder
  environment:
    logstash_ip:   'your-logstash-ip-address'
    logstash_port: '8080'
    logstash_cn:   'your.logstash.server.net'
  volumes:
    - "/var/log:/logs:ro"
```
What we're saying here is monitor my /var/log folder (read only) and post it to your.logstash.server.net.

### SSL Certificates
Logstash forwarder uses SSL certificates to validate against the Logstash server.  The container will generate those and output them to STDOUT when you start it, OR you can mount in a /storage volume which contains them.

You will need to ensure that the listening end is configured to use the same crt and key.  See https://github.com/elastic/logstash-forwarder/blob/master/README.md#use-with-logstash

## License
This application is distributed unter the MIT License (MIT)
