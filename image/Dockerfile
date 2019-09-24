FROM phusion/baseimage:0.9.22
MAINTAINER Schuyler Jager "schuyler@jewlr.com"

ADD . /root/base-files

# Remove the useless /bin/sh and use /bin/bash for all sh commands, plus enable SSHd
RUN echo "Version Bump 5" && \
  rm -f /etc/service/sshd/down && \
  rm /bin/sh && ln -s /bin/bash /bin/sh && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7 && \
  curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -y && \
  apt-get upgrade -y && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends build-essential cloud-init openssl curl \
  nodejs yarn sudo python unzip git-core libcurl4-openssl-dev ruby-dev \
  mysql-client libmysqlclient-dev vim whois libssl-dev libpq-dev \
  postfix libsasl2-modules ntp jq libpcre3-dev awscli zlib1g-dev libpcre3 uuid-dev && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  /bin/bash -l -c "update-alternatives --set editor /usr/bin/vim.basic" && \
  echo "Etc/UTC" > /etc/timezone && \
  dpkg-reconfigure -f noninteractive tzdata && \
  /bin/bash -l -c "update-ca-certificates" && \
  locale-gen en_US en_US.UTF-8 && \
  npm install npm@latest -g && \
  mkdir -p /etc/my_init.d && \
  mkdir /etc/service/nginx && \
  mkdir /root/src && \
  curl -L https://releases.hashicorp.com/vault/0.10.1/vault_0.10.1_linux_amd64.zip -o vault.zip && \
  unzip vault.zip && rm vault.zip && \
  mv vault /usr/local/bin/vault && \
  curl -L https://github.com/coreos/etcd/releases/download/v2.3.7/etcd-v2.3.7-linux-amd64.tar.gz -o etcd-v2.3.7-linux-amd64.tar.gz && \
  tar xzvf etcd-v2.3.7-linux-amd64.tar.gz && \
  mv etcd-v2.3.7-linux-amd64/etcdctl /usr/local/bin/etcdctl && \
  rm -rf etcd-v2.3.7-linux-amd64.tar.gz etcd-v2.3.7-linux-amd64 && \
  echo "Installing GCP Logging Agent, which will always finish even if there is a failure" && \
  curl -sSO https://dl.google.com/cloudagents/install-logging-agent.sh && \
  bash install-logging-agent.sh || true && \
  rm -rf install-logging-agent.sh && \
  echo "Downloading confd" && \
  curl -L https://github.com/kelseyhightower/confd/releases/download/v0.15.0/confd-0.15.0-linux-amd64 -o /usr/local/bin/confd && \
  chmod +x /usr/local/bin/confd && \
  useradd -m -s /bin/bash deploy && \
  usermod -a -G sudo deploy && usermod -p '*' deploy && \
  echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers && \
  mkdir -p /etc/sudoers.d && \
  echo "deploy ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/90-cloud-init-users && \
  chmod +x /root/base-files/install-rvm.sh && \
  ./root/base-files/install-rvm.sh && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem install rubocop vault passenger:6.0.0 --no-document" && \
  git clone https://github.com/schuylr/tiller.git && \
  /bin/bash -c "source /usr/local/rvm/scripts/rvm && cd tiller && gem build tiller.gemspec && gem install tiller-1.0.0.gem && cd ../ && rm -rf tiller" && \
  curl -L http://nginx.org/download/nginx-1.17.2.tar.gz -o nginx.tar.gz && \
  tar zxvf nginx.tar.gz -C /root && rm -rf nginx.tar.gz && \
  NPS_VERSION=1.13.35.2-stable && \
  cd && \
  curl -L https://github.com/pagespeed/ngx_pagespeed/archive/v${NPS_VERSION}.zip -o v${NPS_VERSION}.zip && \
  unzip v${NPS_VERSION}.zip && \
  echo "cd" && \
  cd incubator-pagespeed-ngx-${NPS_VERSION}/ && \
  NPS_RELEASE_NUMBER=1.13.35.2- && \
  psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz && \
  [ -e scripts/format_binary_url.sh ] && psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL) && \
  curl -L ${psol_url} -o psol.tar.gz && \
  tar -xzf psol.tar.gz && \
  echo "PSOL has been extracted" && \
  /bin/bash -c 'source /usr/local/rvm/scripts/rvm && passenger-install-nginx-module --auto --nginx-source-dir=/root/nginx-1.17.2 --prefix=/opt/nginx --extra-configure-flags="--with-http_v2_module --with-http_realip_module --add-module=/root/incubator-pagespeed-ngx-1.13.35.2-stable"' && \
  rm -rf /root/nginx-1.17.2 && \
  cd /root && \
  echo "passenger_root /usr/local/rvm/gems/ruby-2.5.3/gems/`ls /usr/local/rvm/gems/ruby-2.5.3/gems | grep passenger`;" >> /opt/nginx/conf/passenger.conf && \
  echo "passenger_ruby /usr/local/rvm/wrappers/ruby-2.5.3/ruby;" >> /opt/nginx/conf/passenger.conf && \
  curl -L "https://github.com/rancher/cli/releases/download/v0.4.1/rancher-linux-amd64-v0.4.1.tar.gz" -o rancher-cli.tar.gz && \
  tar zxvf rancher-cli.tar.gz && mv rancher-v0.4.1/rancher /usr/local/bin/rancher && \
  rm -rf rancher-cli.tar.gz rancher-v0.4.1 && \
  curl -L "https://github.com/rancher/cli/releases/download/v2.2.0/rancher-linux-amd64-v2.2.0.tar.gz" -o rancher-cli2.tar.gz && \
  tar zxvf rancher-cli2.tar.gz && mv rancher-v2.2.0/rancher /usr/local/bin/rancher2 && \
  rm -rf rancher-cli2.tar.gz rancher-v2.2.0 && \
  /sbin/setuser deploy mkdir /home/deploy/.ssh && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm autolibs packages" && \
  echo "Installing God" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem install god --no-document" && \
  echo "Wrapping God" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm wrapper ruby-2.5.3 bootup god" && \
  echo "Cleaning up RVM" && \
  /sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvmsudo rvm cleanup all" && \
  echo "export TZ=:/etc/localtime" >> /etc/profile

# curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip" && \
# unzip awscli-bundle.zip && \
# ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws && \

   #  --add-module=${PAGE_SPEED_DIR} --with-proxy_protocol
# Page Speed
# ENV NPS_VERSION 1.9.32.6
# RUN wget https://github.com/pagespeed/ngx_pagespeed/archive/release-${NPS_VERSION}-beta.zip -P /root/src;\
#   unzip /root/src/release-${NPS_VERSION}-beta.zip; rm /root/src/release-${NPS_VERSION}-beta.zip
# ENV PAGE_SPEED_DIR /root/src/ngx_pagespeed-release-${NPS_VERSION}-beta/
# RUN wget https://dl.google.com/dl/page-speed/psol/${NPS_VERSION}.tar.gz -P ${PAGE_SPEED_DIR};\
#   tar -xzvf ${PAGE_SPEED_DIR}${NPS_VERSION}.tar.gz -C ${PAGE_SPEED_DIR}; rm ${PAGE_SPEED_DIR}${NPS_VERSION}.tar.gz
#   # extracts to psol/