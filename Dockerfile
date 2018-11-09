FROM python:3.6.5

LABEL maintainer "Gustavo Gama <gustavobgama@gmail.com>"

RUN apt update && apt install -y \
    zip

RUN pip install --upgrade pip

RUN pip install \
    awscli \
    git+https://github.com/westwingbrasil/locust.git \
    git+https://github.com/westwingbrasil/invokust.git \
    gevent~=1.2.2

VOLUME ["/opt/loadtests"]

WORKDIR /opt/loadtests

CMD ["tail", "-f", "/dev/null"]
