# syntax=docker/dockerfile:1

FROM dimitrmok/phirepass-agent:0.1.348 AS binary

FROM dimitrmok/phirepass-base:0.1.348 AS base

RUN apt-get update && \
    apt-get install -y --no-install-recommends nginx && \
    rm -rf /var/lib/apt/lists/*

COPY rootfs /
COPY --from=binary /app/agent /app/agent

RUN chmod +x /app/agent
RUN ln -s /app/agent /usr/local/bin/phirepass
RUN ln -s /app/agent /usr/local/bin/phirepass-agent

RUN chmod +x /app/run.sh

RUN echo "alias btop='btop --utf-force'" >> /root/.bashrc

ENV RUST_LOG=info

EXPOSE 8080
EXPOSE 8081

CMD [ "/app/run.sh" ]
