module tui

import os
import x.json2

pub fn retrieve_theme_pack(theme_pack string) Config
{
	mut c := Config{term: Terminal{}, graph: Graph_Display{}, conntable: Conntable_Display{}, os: OS_Display{}, hdw: Hardware_Display{}, conn: Connection_Display{}}
	c.theme_pack_path = "assets/themes/${theme_pack}/"

	file_data := os.read_file("${c.theme_pack_path}text_position.json") or { "" }
	c.ui = os.read_file("${c.theme_pack_path}ui.txt") or { "" }
	c.text_data := json2.raw_decode(file_data) or { return c }
	c.graph = os.read_file("${c.theme_pack_path}graph.txt") or { "" }

	return c
}