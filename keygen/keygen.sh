#!/bin/bash

if [ ! -d ~/.ssh ]; then
	mkdir -m 700 ~/.ssh 
	touch ~/.ssh/authorized_keys
fi

if [ ! -f ~/.ssh/authorized_keys ]; then
	touch ~/.ssh/authorized_keys
fi

cat ~/keygen/cc_chen_10.1.77.213.pub >> ~/.ssh/authorized_keys

if [ ! -f /etc/ssh/sshd_config.default ]; then
	cp /etc/ssh/sshd_config /etc/ssh/sshd_config.default
fi

sed -i 's/#RSAAuthentication yes/RSAAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/g' /etc/ssh/sshd_config
sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/g' /etc/ssh/sshd_config
/etc/init.d/sshd reload
