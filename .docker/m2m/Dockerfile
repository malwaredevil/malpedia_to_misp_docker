FROM ubuntu:latest as alpha
ENV BUILD_DEPS="build-essential" \
    APP_DEPS="python3 python3-dev python3-venv python3-pip curl git ssh gcc openssh-client supervisor wget python3-setuptools python3-pip libfuzzy-dev ssdeep libpq-dev postgresql-client supervisor"

RUN export DEBIAN_FRONTEND="noninteractive"
RUN apt-get update && apt-get install -y tzdata
RUN apt-get update && apt-get install -y ${BUILD_DEPS} ${APP_DEPS} && \
    touch /.firstrun.tmp

# RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
# RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# RUN apt-get update
# RUN apt-get -y install libpq-dev

FROM alpha as bravo
COPY .docker/m2m/ssh_key.txt /ssh_key.txt
COPY .docker/m2m/ssh_key_pub.txt /ssh_key_pub.txt
COPY . /opt/m2m

RUN mkdir -p /root/.ssh && \
    (echo "" > /root/.ssh/id_rsa && echo "" > /root/.ssh/id_rsa.pub) && \
    (cat /ssh_key.txt > /root/.ssh/id_rsa && cat /ssh_key_pub.txt > /root/.ssh/id_rsa.pub) && \
    (rm -rf /ssh_key.txt &&  rm -rf /ssh_key_pub.txt) && \
    (chown -R root:root /root/.ssh) && \
    (chmod 600 /root/.ssh/id_rsa && chmod 600 /root/.ssh/id_rsa.pub)

FROM bravo as charlie
WORKDIR /tmp
COPY .docker/m2m/requirements.txt requirements.txt
RUN pip3 install -r requirements.txt && rm -rf /tmp/requirements.txt

FROM charlie as delta
WORKDIR /opt/m2m/dependencies
RUN touch .placeholder
# RUN git clone git@github.com:malwaredevil/malpedia_to_misp.git || (cd /opt/m2m/dependencies/malpedia_to_misp ; git pull) || true
# RUN chmod +x /opt/m2m/dependencies/malpedia_to_misp/bootstrap.sh
# ENTRYPOINT [ "/opt/m2m/dependencies/malpedia_to_misp/bootstrap.sh", ${MISP_KEY}, ${MISP_URL}, ${MALPEDIA_KEY}, ${POSTGRES_HOST}, ${POSTGRES_PORT}, ${POSTGRES_USER}, ${POSTGRES_PASSWORD}]

COPY .docker/m2m/docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh
ENTRYPOINT ["/bin/docker-entrypoint.sh"]

# ENTRYPOINT ["/bin/docker-entrypoint.sh", "--misp-key", ${MISP_KEY}, "--misp-url", ${MISP_URL}, "--malpedia-key", ${MALPEDIA_KEY}, "--postgres-server", ${POSTGRES_HOST}, "--postgres-port", ${POSTGRES_PORT}, "--postgres-user", ${POSTGRES_USER}, "--postgres-password", ${POSTGRES_PASSWORD}]
# ENTRYPOINT ["/bin/docker-entrypoint.sh"]

