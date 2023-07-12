FROM ubuntu:22.04

COPY check /opt/resource/check
COPY in    /opt/resource/in
COPY out   /opt/resource/out

RUN chmod +x /opt/resource/out /opt/resource/in /opt/resource/check && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y curl jq

