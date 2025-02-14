FROM amazonlinux:latest

RUN yum install -y jq aws-cli

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]