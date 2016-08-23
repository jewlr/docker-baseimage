FROM phusion/baseimage:0.9.19
MAINTAINER Schuyler Jager "schuyler@jewlr.com"

# Remove the useless /bin/sh and use /bin/bash for all sh commands, plus enable SSHd
RUN rm -f /etc/service/sshd/down && \
  rm /bin/sh && ln -s /bin/bash /bin/sh && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
  echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list && \
  apt-get update -y && \
  apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential cloud-init openssl curl \
  nodejs sudo python unzip git-core nginx-extras passenger \
  mysql-client libmysqlclient-dev vim fail2ban \
  postfix libsasl2-modules && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  /bin/bash -l -c "update-alternatives --set editor /usr/bin/vim.basic" && \
  echo "America/Toronto" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  /bin/bash -l -c "update-ca-certificates" && \
  locale-gen en_US en_US.UTF-8 && \
  mkdir -p /etc/my_init.d && \
  mkdir /etc/service/nginx && \
  mkdir /root/src && \
  curl -L https://github.com/coreos/etcd/releases/download/v2.3.7/etcd-v2.3.7-linux-amd64.tar.gz -o etcd-v2.3.7-linux-amd64.tar.gz && \
  tar xzvf etcd-v2.3.7-linux-amd64.tar.gz && \
  mv etcd-v2.3.7-linux-amd64/etcdctl /usr/local/bin/etcdctl && \
  rm -rf etcd-v2.3.7-linux-amd64.tar.gz etcd-v2.3.7-linux-amd64 && \
  curl -L https://github.com/kelseyhightower/confd/releases/download/v0.11.0/confd-0.11.0-linux-amd64 -o /usr/local/bin/confd && \
  chmod +x /usr/local/bin/confd && \
  gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 && \
  curl -sSL https://get.rvm.io | bash -s stable && \
  useradd -m -s /bin/bash deploy; usermod -a -G rvm deploy; usermod -a -G sudo deploy; usermod -p '*' deploy && \
  echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers; echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/90-cloud-init-users && \
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"; unzip awscli-bundle.zip;\
    ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \
  /sbin/setuser deploy mkdir /home/deploy/.ssh && \
  /sbin/setuser deploy /bin/bash -c -c "source /etc/profile.d/rvm.sh && rvm autolibs packages" && \
  /sbin/setuser deploy /bin/bash -l -c "source /etc/profile.d/rvm.sh && rvm install 2.3.0 --default" && \
  /sbin/setuser deploy /bin/bash -l -c "source /etc/profile.d/rvm.sh && gem install god --no-document" && \
  /sbin/setuser deploy /bin/bash -l -c "source /etc/profile.d/rvm.sh && rvm wrapper ruby-2.3.0 bootup god" && \
  /sbin/setuser deploy /bin/bash -l -c "source /etc/profile.d/rvm.sh && rvmsudo rvm cleanup all"
   #  --add-module=${PAGE_SPEED_DIR} --with-proxy_protocol
# Page Speed
# ENV NPS_VERSION 1.9.32.6
# RUN wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -P /root/src;\
#   unzip /root/src/release-${NPS_VERSION}-beta.zip; rm /root/src/release-${NPS_VERSION}-beta.zip
# ENV PAGE_SPEED_DIR /root/src/ngx_pagespeed-release-${NPS_VERSION}-beta/
# RUN wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz -P ${PAGE_SPEED_DIR};\
#   tar -xzvf ${PAGE_SPEED_DIR}${NPS_VERSION}.tar.gz -C ${PAGE_SPEED_DIR}; rm ${PAGE_SPEED_DIR}${NPS_VERSION}.tar.gz
#   # extracts to psol/
