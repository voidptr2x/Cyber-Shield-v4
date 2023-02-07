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

	// c.ui = c.replace_color_code(c.ui)

	c.text = j.raw_decode(file_data) or { return c }
	c.graph_layout = os.read_file("${c.theme_pack_path}graph.txt") or { 
		print("[x] Error - UNDBUIasjszw, Unable to locate or read ${c.theme_pack_path}graph.txt")
		exit(0)	
	}

	return c
}

pub fn (mut c Config) retrieve_os_cfg() map[string]j.Any
{
	os_d := c.text.as_map()['OS_Display'] or {
		print("[!] Error - sN6kyZjI0oNH, Missing 'OS_Display' structure in JSON file....!")
		exit(0)
	}
	return (j.raw_decode("${os_d}") or { return map[string]j.Any{} }).as_map()
}

pub fn (mut c Config) retrieve_hdw_cfg() map[string]j.Any
{
	hdw_d := c.text.as_map()['Hardware_Display'] or {
		print("[!] Error - X3pm0slbVA55, Missing 'Hardware_Display' structure in JSON file....!")
		exit(0)
	}
	return (j.raw_decode("${hdw_d}") or { return map[string]j.Any{} }).as_map()
}

pub fn (mut c Config) retrieve_conn_cfg() map[string]j.Any
{
	con_d := c.text.as_map()['Connection_Display'] or {
		print("[!] Error - X3pm0slbVA55, Missing 'Connection_Display' structure in JSON file....!")
		exit(0)
	}
	return (j.raw_decode("${con_d}") or { return map[string]j.Any{} }).as_map()
}

pub fn (mut c Config) retrieve_term_cfg() map[string]j.Any
{
	con_d := c.text.as_map()['Terminal'] or {
		print("[!] Error - X3pm0slbVA55, Missing 'Terminal' structure in JSON file....!")
		exit(0)
	}
	return (j.raw_decode("${con_d}") or { return map[string]j.Any{} }).as_map()
}

pub fn (mut c Config) retrieve_graph_cfg() map[string]j.Any
{
	graph_d := c.text.as_map()['Graph_Display'] or {
		print("[!] Error - X3pm0slbVA55, Missing 'Graph_Display' structure in JSON file....!")
		exit(0)
	}
	return (j.raw_decode("${graph_d}") or { return map[string]j.Any{} }).as_map()
}