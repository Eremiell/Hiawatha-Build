#!/bin/bash

# sudo apt-get install cmake libc6-dev libssl-dev dpkg-dev debhelper fakeroot libxml2-dev libxslt1-dev

cleanup() {
	cd ~/hiawatha-build
	if [ -f latest ]; then
		rm -rf hiawatha-$(cat latest)
		rm -f hiawatha-$(cat latest).tar.gz
		rm -f latest
	fi
	if [ $(echo -n $(grep -c "" log)) -gt 1000 ]; then
		tail -n1000 log > log
	fi
}

mkdir -p ~/hiawatha-build
cd ~/hiawatha-build
wget https://www.hiawatha-webserver.org/latest >> log 2>> log
if [ $? != 0 ]; then
	echo "!latest not present on server or cannot connect" >> log
	cleanup
	exit 1
fi
if [ -f lastlatest ]; then
	diff latest lastlatest >> log 2>> log
else
	diff "a" "b" 2> /dev/null
fi
if [ $? == 0 ]; then
	echo ".latest version $(cat latest) already installed" >> log
	cleanup
	exit 0
fi
wget https://www.hiawatha-webserver.org/files/hiawatha-$(cat latest).tar.gz >> log 2>> log
if [ $? != 0 ]; then
	echo "!tarball not present on server or cannot connect" >> log
	cleanup
	exit 2
fi
tar -xzvf hiawatha-$(cat latest).tar.gz >> /dev/null 2>> log
if [ $? != 0 ]; then
	echo "!tarball corrupted" >> log
	cleanup
	exit 3
fi
cd hiawatha-$(cat latest)/extra
./make_debian_package >> log 2>> ../../log
if [ $? != 0 ]; then
	echo "!build unsuccessful" >> ../../log
	cleanup
	exit 4
fi
cd ..
dpkg -i hiawatha_$(cat ../latest)_$(echo -n $(dpkg --print-architecture)).deb >> ../log 2>> ../log
if [ $? != 0 ]; then
	echo "!install unsuccessful" >> ../log
	cleanup
	exit 5
fi
/etc/init.d/hiawatha restart >> ../log 2>> ../log
if [ $? != 0 ]; then
	echo "!restart unsuccessful" >> ../log
	cleanup
	exit 6
fi
echo ".latest build $(cat ../latest) successfully installed" >> ../log
cp ../latest ../lastlatest
cleanup
exit 0
