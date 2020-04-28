#!/bin/bash

/sbin/setuser deploy /bin/bash -l -c "gpg2 --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB"
/sbin/setuser deploy /bin/bash -l -c "curl -sSL https://get.rvm.io | sudo bash -s -- --version 1.29.3 --ruby=2.5.3"
usermod -a -G rvm deploy
/sbin/setuser deploy /bin/bash -l -c "source /usr/local/rvm/scripts/rvm && gem update --system 3.0.2"