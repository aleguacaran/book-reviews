FROM ruby:3.4.5-slim AS base

RUN apt update
RUN apt upgrade -y
RUN apt install -y build-essential libpq-dev libyaml-dev curl

RUN curl -fsSL https://deb.nodesource.com/setup_23.x | bash -
RUN apt install -y nodejs
RUN npm install -g npm yarn

ENV DIR=/var/www

RUN mkdir $DIR
WORKDIR $DIR

ENV GEM_HOME=/bundle
ENV BUNDLE_PATH=/bundle
ENV BUNDLE_BIN=/bundle/bin
ENV BUNDLE_APP_CONFIG=/bundle
ENV PATH=/bundle/bin:$PATH

COPY . .

FROM base AS development

ENTRYPOINT ["./start.sh"]
