FROM ubuntu:16.04

RUN apt-get -qq update && apt-get upgrade -y
RUN apt-get install -y curl sudo git

# sshd
RUN apt-get install -y --no-install-recommends openssh-server curl
RUN echo "root:Docker!" | chpasswd
RUN mkdir /var/run/sshd
COPY sshd_config /etc/ssh/

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo bash -
RUN apt-get install -y nodejs

# Application
COPY app /usr/src/app
WORKDIR /usr/src/app
RUN npm install

# Set supervisor
RUN apt-get install -y supervisor
ADD supervisor/supervisord.conf /etc/supervisord.conf

EXPOSE 5566 2222

CMD ["/usr/bin/supervisord"]