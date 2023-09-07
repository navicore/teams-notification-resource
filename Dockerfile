FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq

COPY check   /opt/resource/check
COPY in      /opt/resource/in
COPY out     /opt/resource/out
COPY card.jq /opt/resource/card.jq

RUN chmod +x /opt/resource/out /opt/resource/in /opt/resource/check