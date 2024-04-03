FROM phusion/baseimage:jammy-1.0.1
MAINTAINER Stan Cheng "stan@jewlr.com"

ADD . /root/base-files

# Remove the useless /bin/sh and use /bin/bash for all sh commands, plus enable SSHd
RUN echo "Version Bump 8" && \
  rm -f /etc/service/sshd/down && \
  rm /bin/sh && ln -s /bin/bash /bin/sh

RUN echo "Adding Ubuntu keys and installing ca-certs with wget" && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
  apt update && apt install ca-certificates wget && \
  apt-key adv --refresh-keys --keyserver hkp://keyserver.ubuntu.com:80

RUN echo "Installing Node 18 and yarn" &&\
  curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  npm install npm@latest -g && \
  mkdir -p /etc/my_init.d && \
  mkdir /root/src

RUN echo "Installing all dependancies" && \
  apt-get --assume-yes --verbose-versions --allow-change-held-packages -o Dpkg::Options::="--force-confdef" upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential cloud-init openssl curl \
  nodejs yarn sudo python-is-python3 unzip git-core libcurl4-openssl-dev ruby-dev gnupg2 cronic dnsutils \
  mysql-client libmysqlclient-dev vim whois libssl-dev libpq-dev libjemalloc-dev \
  postfix libsasl2-modules ntp jq libpcre3-dev zlib1g-dev libpcre3 uuid-dev rustc && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "Installing  mongosh and mongodb tools if we need to pull secrets from mongo backup" &&\
  wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | tee /etc/apt/trusted.gpg.d/server-7.0.asc && \
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-7.0.list && \
  apt-get update && apt-get install -y mongodb-mongosh && \
  wget https://fastdl.mongodb.org/tools/db/mongodb-database-tools-ubuntu2204-x86_64-100.9.0.deb && \
  apt install ./mongodb-database-tools-ubuntu2204-x86_64-100.9.0.deb && \
  apt-get update -y

RUN echo "Setting up timezone and updating certs" && \
  /bin/bash -l -c "update-alternatives --set editor /usr/bin/vim.basic" && \
  echo "Etc/UTC" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  /bin/bash -l -c "update-ca-certificates" && \
  locale-gen en_US en_US.UTF-8

RUN echo "Installing Vault" && \
  curl -L https://releases.hashicorp.com/vault/0.10.4/vault_0.10.4_linux_amd64.zip -o vault.zip && \
  unzip vault.zip && rm vault.zip && \
  mv vault /usr/local/bin/vault

RUN echo "Installing etcd" && \
  tar xzvf etcd-v2.3.7-linux-amd64.tar.gz && \
  mv etcd-v2.3.7-linux-amd64/etcdctl /usr/local/bin/etcdctl && \
  rm -rf etcd-v2.3.7-linux-amd64.tar.gz etcd-v2.3.7-linux-amd64

RUN echo "Installing GCP Ops Agent, which will always finish even if there is a failure" && \
  curl -sSO https://dl.google.com/cloudagents/add-google-cloud-ops-agent-repo.sh && \
  bash add-google-cloud-ops-agent-repo.sh --also-install && \
  rm -rf add-google-cloud-ops-agent-repo.sh

RUN echo "Downloading confd" && \
  curl -L https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -o /usr/local/bin/confd && \
  chmod +x /usr/local/bin/confd

RUN echo "Adding deploy user and group" && \
  useradd -m -s /bin/bash deploy && \
  usermod -a -G sudo deploy && usermod -p '*' deploy && \
  echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
  mkdir -p /etc/sudoers.d && \
  echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/90-cloud-init-users

RUN echo "Installing rvm and ruby" && \
  chmod +x /root/base-files/install-rvm.sh && \
  ./root/base-files/install-rvm.sh

RUN echo "Installing gem-wrappers, autolibs, god and cleaning up RVM" && \
  # Try to work around bug in rvm/gem_wrappers related to ruby gem vesion > 3.2.17
  # https://github.com/rvm/gem-wrappers/issues/15
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem install gem-wrappers --no-document" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem install rubocop vault --no-document" && \
  /sbin/setuser deploy mkdir /home/deploy/.ssh && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm autolibs packages" && \
  echo "Installing God" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem install specific_install --no-document" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem specific_install -l http://github.com/jewlr/god.git" && \
  echo "Showing God Wrapper" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm wrapper show god" && \
  echo "Cleaning up RVM" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvmsudo rvm cleanup all" && \
  echo "export TZ=:/etc/localtime" >> /etc/profile
