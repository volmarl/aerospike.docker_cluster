#
# Aerospike Server Dockerfile
#
# http://github.com/aerospike/aerospike-server.docker
#

FROM ubuntu:latest

ENV AEROSPIKE_VERSION 3.6.3 
# ENV AEROSPIKE_SHA256 fc01f6d5cca3b91ade07bef83254921f3dea30a63331eabeb8ff3f11138a6330 

# Install Aerospike
RUN \
  apt-get update -y \
  && apt-get install -y wget logrotate ca-certificates \
  && wget "https://www.aerospike.com/artifacts/aerospike-server-community/${AEROSPIKE_VERSION}/aerospike-server-community-${AEROSPIKE_VERSION}-debian7.tgz" -O aerospike-server.tgz \
  && mkdir aerospike \
  && tar xzf aerospike-server.tgz --strip-components=1 -C aerospike \
  && dpkg -i aerospike/aerospike-server-*.deb \
  && apt-get purge -y --auto-remove wget ca-certificates \
  && rm -rf aerospike-server.tgz aerospike /var/lib/apt/lists/*

# Add the Aerospike configuration specific to this dockerfile
ADD aerospike.conf /etc/aerospike/aerospike.conf

# Mount the Aerospike data directory
VOLUME ["/opt/aerospike/data"]

# Expose Aerospike ports
#
#   3000 – service port, for client connections
#   3001 – fabric port, for cluster communication
#   3002 – mesh port, for cluster heartbeat
#   3003 – info port
#
EXPOSE 3000 3001 3002 3003

# Execute the run script in foreground mode
CMD ["/usr/bin/asd","--foreground"]
