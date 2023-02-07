.PHONY: all

all: install_dependency

install_dependency: 
	sudo apt update
	sudo apt-get install libexpat1-dev libssl-dev libcurl4-openssl-dev

build:
	/bin/v/v shield.v -o shield_glib_2.35_x86_64 -prod
