module tui

import os
import x.json2 as j

pub const COLOR_CODES = {
	'{Bold}': '\x1b[1m',
	'{Reset_Term}': '\x1b[0m',
	'{Reset_Bold}': '\x1b[21m',
	'{Default}': '\x1b[39m',
	'{Black}': '\x1b[30m',
	'{Red}': '\x1b[31m',
	'{Green}': '\x1b[32m',
	'{Yellow}': '\x1b[33m',
	'{Blue}': '\x1b[34m',
	'{Purple}': '\x1b[35m',
	'{Cyan}': '\x1b[36m',
	'{Light_Grey}': '\x1b[37m',
	'{Dark_Grey}': '\x1b[90m',
	'{Light_Red}': '\x1b[91m',
	'{Light_Green}': '\x1b[92m',
	'{Light_Yellow}': '\x1b[93m',
	'{Light_Blue}': '\x1b[94m',
	'{Light_Purple}': '\x1b[95m',
	'{Light_Cyan}': '\x1b[96m',
	'{White}': '\x1b[97m',
	// Background Colors
	'{Default_BG}': '\x1b[49m',
	'{Black_BG}': '\x1b[40m',
	'{Red_BG}': '\x1b[41m',
	'{Green_BG}': '\x1b[42m',
	'{Yellow_BG}': '\x1b[43m',
	'{Blue_BG}': '\x1b[44m',
	'{Purple_BG}': '\x1b[45m',
	'{Cyan_BG}': '\x1b[46m',
	'{Light_Grey_BG}': '\x1b[47m',
	'{Dark_Grey_BG}': '\x1b[100m',
	'{Light_Red_BG}': '\x1b[101m',
	'{Light_Green_BG}': '\x1b[102m',
	'{Light_Yellow_BG}': '\x1b[103m',
	'{Light_Blue_BG}': '\x1b[104m',
	'{Light_Purple_BG}': '\x1b[105m',
	'{Light_Cyan_BG}': '\x1b[106m',
	'{White_BG}': '\x1b[107m',
	'{Clear}': '\033[2J\033[1;1H',
}

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

pub fn (mut c Config) replace_color_code(text string) string
{
	mut new := text
	for key, val in COLOR_CODES
	{
		if new.contains(key)
		{
			new = new.replace(key, val)
		}
	}
	return new
}

pub fn (mut c Config) retrieve_graph_cfg() map[string]j.Any
{
	graph_d := c.text.as_map()['Graph_Display'] or {
		print("[!] Error - X3pm0slbVA55, Missing 'Graph_Display' structure in JSON file....!")
		exit(0)
	}
	return (j.raw_decode("${graph_d}") or { return map[string]j.Any{} }).as_map()
}