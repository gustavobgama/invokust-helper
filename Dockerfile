FROM python:3.6-alpine

LABEL maintainer "Gustavo Gama <gustavobgama@gmail.com>"

RUN apk update && apk --no-cache add \
    git \
    g++ \
    zeromq-dev \
    libffi-dev

RUN pip install --upgrade pip

RUN pip install \
    awscli \
    git+https://github.com/westwingbrasil/locust.git \
    git+https://github.com/westwingbrasil/invokust.git \
    gevent~=1.2.2

RUN apk del git \
    g++ \
    libffi-dev

VOLUME ["/opt/loadtests"]

WORKDIR /opt/loadtests

CMD ["tail", "-f", "/dev/null"]
