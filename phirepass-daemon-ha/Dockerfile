# syntax=docker/dockerfile:1

FROM dimitrmok/phirepass-agent:0.1.231 AS binary

FROM dimitrmok/phirepass-base:0.1.232 AS base

COPY rootfs /
COPY --from=binary /app/agent /app/agent

RUN chmod +x /app/agent
RUN ln -s /app/agent /usr/local/bin/phirepass
RUN ln -s /app/agent /usr/local/bin/phirepass-agent

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
