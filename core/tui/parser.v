module tui

import os
import x.json2 as j

pub fn retrieve_theme_pack(theme_pack string) Config
{
	mut c := Config{term: Terminal{}, graph: Graph_Display{}, conntable: Conntable_Display{}, os: OS_Display{}, hdw: Hardware_Display{}, conn: Connection_Display{}}
	c.theme_pack_path = "assets/themes/${theme_pack}/"

	file_data := os.read_file("${c.theme_pack_path}text_position.json") or { 
		print("[x] Error - RmCrx0tRizIi, Unable to locate or read ${c.theme_pack_path}text_position.json")
		exit(0)
	}
	c.ui = os.read_file("${c.theme_pack_path}ui.txt") or { 
		print("[x] Error - 3okOha8zBxpm, Unable to locate or read ${c.theme_pack_path}ui.txt")
		exit(0)
	}
	c.text = j.raw_decode(file_data) or { return c }
	c.graph_layout = os.read_file("${c.theme_pack_path}graph.txt") or { 
		print("[x] Error - UNDBUIasjszw, Unable to locate or read ${c.theme_pack_path}graph.txt")
		exit(0)	
	}

	return c
}

pub fn (mut c Config) retrieve_os_cfg() map[string]j.Any
{
	return (j.raw_decode("${c.text.as_map()['OS_Display']}") or { return map[string]j.Any{} }).as_map()
}

pub fn (mut c Config) retrieve_hdw_cfg() map[string]j.Any
{
	return (j.raw_decode("${c.text.as_map()['Hardware_Display']}") or { return map[string]j.Any{} }).as_map()
}