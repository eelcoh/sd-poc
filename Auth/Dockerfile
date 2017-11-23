FROM scratch
MAINTAINER Eelco Hoekema <ehoekema@gmail.com>

ADD cert.pem /etc/ssl/certs/
ADD bin/auth auth

EXPOSE 5556
ENTRYPOINT ["/auth"]
