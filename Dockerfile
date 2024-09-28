# syntax=docker/dockerfile:1

FROM alpine AS builder
ARG LUA_VERSION=5.1

RUN apk update && apk upgrade
RUN apk add --no-cache \
  ca-certificates curl \
  build-base gcc git make cmake \
	luajit lua-dev lua${LUA_VERSION} \
	luarocks

RUN ln -s /usr/bin/luarocks-${LUA_VERSION} /usr/bin/luarocks
RUN luarocks config --scope system lua_dir /usr

FROM builder AS soft

RUN apk add --no-cache \
  mongo-c-driver-static \
  libbson-static \
  openssl \
  openssl-dev

RUN luarocks install --dev https://raw.githubusercontent.com/luatoolz/lua-mongo/master/lua-mongo-scm-0.rockspec
RUN luarocks install --dev t-format-bson

COPY . /app
WORKDIR /app

RUN luarocks test --prepare --dev t-format-bson-scm-0.rockspec
RUN luarocks install --deps-mode all --only-deps --dev *.rockspec
RUN luarocks build --deps-mode all --dev *.rockspec

RUN apk del build-base gcc git make cmake openssl-dev && rm -rf /var/cache

FROM scratch
COPY --from=soft / /

WORKDIR /app
