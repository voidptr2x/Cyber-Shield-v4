module tui

import os

const path_to_config = "assets/"

pub fn (mut c Config) retrieve_config_info() {
	c.config_data = os.read_file("${path_to_config}config.json") or {
		print("[!] Error, Unable to read app config file....")
		exit(0)
	}
	c.protection_data = os.read_file("${path_to_config}protection.json") or {
		print("[!] Error, Unable to read protection config file....")
		exit(0)
	}
}