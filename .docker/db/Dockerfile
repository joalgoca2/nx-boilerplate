ARG DB_DOCKER_IMAGE_TAG
FROM mariadb:${DB_DOCKER_IMAGE_TAG}

#-----------------------------------------------------------------------------------------------------------------------

HEALTHCHECK \
  --interval=10s \
  --timeout=10s \
  --start-period=5s \
  --retries=3 \
  CMD bash /usr/local/bin/healthcheck.sh --su-mysql --connect

#-----------------------------------------------------------------------------------------------------------------------

CMD ["mariadbd"]
