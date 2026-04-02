# syntax=docker/dockerfile:1

FROM dimitrmok/phirepass-agent:0.1.183 AS binary

FROM debian:trixie-slim

RUN apt-get update && apt-get install -y \
    pkg-config \
    libssl-dev \
    openssh-server \
    htop \
    btop \
    locales \
    gcc-aarch64-linux-gnu \
    g++-aarch64-linux-gnu \
    libc6-dev-arm64-cross \
    build-essential \
    git \
    vim \
    make \
    cmake \
    perl \
    golang \
    autoconf \
    ninja-build \
    curl \
    jq \
    sudo \
 && rm -rf /var/lib/apt/lists/* \
 && mkdir -p /var/run/sshd

COPY rootfs /
COPY --from=binary /app/agent /app/agent

RUN chmod +x /app/run.sh

RUN sed -i 's/^# *en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8

ENV LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

RUN echo "alias btop='btop --utf-force'" >> /root/.bashrc

ENV RUST_LOG=info

EXPOSE 8080

CMD [ "/app/run.sh" ]
