#!/bin/bash

# /sbin/setuser deploy /bin/bash -l -c "sudo gpg2 --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
/sbin/setuser deploy /bin/bash -l -c "curl -sSL https://rvm.io/mpapis.asc | sudo gpg2 --import -"
/sbin/setuser deploy /bin/bash -l -c "curl -sSL https://rvm.io/pkuczynski.asc | sudo gpg2 --import -"
/sbin/setuser deploy /bin/bash -l -c "curl -sSL https://get.rvm.io | sudo bash -s" # -- --version 1.29.3"
usermod -a -G rvm deploy
/sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm install 3.2.2 -C --with-jemalloc --reconfigure --enable-yjit && rvm use --default 3.2.2"
# Install ruby 2.7.6 for backwards compatibility until app images have been merged to all branches
/sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && rvm install 2.7.6 -C --with-jemalloc"
/sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem update --system 3.4.15 --no-document"
