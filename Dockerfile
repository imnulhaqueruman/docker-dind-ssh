FROM docker:stable-dind

COPY dockerd-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/dockerd-entrypoint.sh

RUN apk add --no-cache openssh-server
EXPOSE 22

RUN adduser -D -h /home/term -s /bin/sh term && \
    ( echo "term:term" | chpasswd )
RUN sed -i s/#PermitRootLogin.*/PermitRootLogin\ yes/ /etc/ssh/sshd_config \
  && sed -i s/#PermitEmptyPasswords.*/PermitEmptyPasswords\ yes/ /etc/ssh/sshd_config \
  && sed -i s/#PermitUserEnvironment.*/PermitUserEnvironment\ yes/ /etc/ssh/sshd_config \
  && passwd -d root
RUN ssh-keygen -A
# RUN addgroup -S docker && adduser -S root -G docker
CMD ["dockerd-entrypoint.sh"]