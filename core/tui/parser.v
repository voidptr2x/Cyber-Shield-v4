module tui

import os
import x.json2

pub fn start_theme_pack() Config
{
	mut c := Config{term: Terminal{}, graph: Graph_Display{}, conntable: Conntable_Display{}, os: OS_Display{}, hdw: Hardware_Display{}, conn: Connection_Display{}}
	t := os.read_file("assets/themes/builtin/text_position.json") or { "" }
	gang := json2.raw_decode(t) or { return c }

	for key, val in gang.as_map()
	{
		structure_info := json2.raw_decode("${val}") or { return c }
		print("${key}: \n")

		for k, v in structure_info.as_map()
		{
			print("\t${k}: ${v}\n")
		}
	}
	return c
}