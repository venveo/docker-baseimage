FROM alpine:edge
MAINTAINER Ransom Roberson <ransom@venveo.com>

WORKDIR /tmp

# Add CURL and required php7 extensions
RUN apk --update --repository=http://dl-4.alpinelinux.org/alpine/edge/testing add \
    nodejs-npm \
    nodejs

RUN rm -fr /var/cache/apk/*

RUN apk add --update \
    python \
    python-dev \
    py-pip \
    build-base \
    git \
    openssh-client \
  && pip install virtualenv \
  && rm -rf /var/cache/apk/*

WORKDIR /app
RUN npm install gulp -g
RUN npm install -g bower

ENTRYPOINT ["gulp"]
CMD ["--version"]