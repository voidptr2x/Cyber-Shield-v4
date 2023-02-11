.PHONY: all

all: install_dependency build

install_dependency: 
	sudo apt update -y
	sudo apt install net-tools git gcc speedtest-cli -y 
	sudo apt-get install libexpat1-dev libssl-dev libcurl4-openssl-dev -y
	cd /tmp
	git clone https://github.com/vlang/v.git
	cd v; sudo make
	./v symlink

build:
	/bin/v/v shield.v -o shield_glib_2.35_x86_64 -prod
	cp shield_glib_2.35_x86_64 shield
	mv shield_glib_2.35_x86_64 binary_builds/
	echo -ne '\x1b[31mShield Successfully Build]\x1b[0m'