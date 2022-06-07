FROM phusion/baseimage:bionic-1.0.0
MAINTAINER Stan Cheng "stan@jewlr.com"

ADD . /root/base-files

# Remove the useless /bin/sh and use /bin/bash for all sh commands, plus enable SSHd
RUN echo "Version Bump 8" && \
  rm -f /etc/service/sshd/down && \
  rm /bin/sh && ln -s /bin/bash /bin/sh && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
  apt update && apt install ca-certificates && \
  apt-key adv --refresh-keys --keyserver hkp://keyserver.ubuntu.com:80 && \
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null && \
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
  apt-get update -y && \
  echo 'DPkg::options { "--force-confdef"; };' >> /etc/apt/apt.conf && \
  apt-get --assume-yes --verbose-versions --allow-change-held-packages -o Dpkg::Options::="--force-confdef" upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential cloud-init openssl curl \
  nodejs yarn sudo python unzip git-core libcurl4-openssl-dev ruby-dev gnupg2 cronic \
  mysql-client libmysqlclient-dev vim whois libssl-dev libpq-dev libjemalloc-dev \
  postfix libsasl2-modules ntp jq libpcre3-dev zlib1g-dev libpcre3 uuid-dev google-cloud-sdk && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  /bin/bash -l -c "update-alternatives --set editor /usr/bin/vim.basic" && \
  echo "Etc/UTC" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  /bin/bash -l -c "update-ca-certificates" && \
  locale-gen en_US en_US.UTF-8 && \
  npm install npm@latest -g && \
  mkdir -p /etc/my_init.d && \
  mkdir /root/src && \
  curl -L https://releases.hashicorp.com/vault/0.10.4/vault_0.10.4_linux_amd64.zip -o vault.zip && \
  unzip vault.zip && rm vault.zip && \
  mv vault /usr/local/bin/vault && \
  curl -L https://github.com/etcd-io/etcd/releases/download/v2.3.7/etcd-v2.3.7-linux-amd64.tar.gz -o etcd-v2.3.7-linux-amd64.tar.gz && \
  tar xzvf etcd-v2.3.7-linux-amd64.tar.gz && \
  mv etcd-v2.3.7-linux-amd64/etcdctl /usr/local/bin/etcdctl && \
  rm -rf etcd-v2.3.7-linux-amd64.tar.gz etcd-v2.3.7-linux-amd64 && \
  echo "Installing GCP Logging Agent, which will always finish even if there is a failure" && \
  curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh && \
  bash install-logging-agent.sh || true && \
  rm -rf install-logging-agent.sh && \
  echo "Downloading confd" && \
  curl -L https://github.com/kelseyhightower/confd/releases/download/v0.16.0/confd-0.16.0-linux-amd64 -o /usr/local/bin/confd && \
  chmod +x /usr/local/bin/confd && \
  useradd -m -s /bin/bash deploy && \
  usermod -a -G sudo deploy && usermod -p '*' deploy && \
  echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
  mkdir -p /etc/sudoers.d && \
  echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/90-cloud-init-users && \
  chmod +x /root/base-files/install-rvm.sh && \
  ./root/base-files/install-rvm.sh && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem install rubocop vault --no-document" && \
  /sbin/setuser deploy mkdir /home/deploy/.ssh && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm autolibs packages" && \
  echo "Installing God" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem install god --no-document" && \
  echo "Showing God Wrapper" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm wrapper show god" && \
  echo "Cleaning up RVM" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvmsudo rvm cleanup all" && \
  echo "export TZ=:/etc/localtime" >> /etc/profile
