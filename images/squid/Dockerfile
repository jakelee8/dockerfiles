FROM alpine
MAINTAINER Jake Lee <jake@jakelee.net>

ENV CACHE_EFFECTIVE_USER=squid
ENV CACHE_EFFECTIVE_GROUP=squid

RUN apk add --update --no-cache squid

VOLUME /var/cache/squid
VOLUME /var/log/squid

EXPOSE 3128

ADD start.sh /sbin/start.sh
RUN chmod 755 /sbin/start.sh
CMD ["/sbin/start.sh", "-N"]
