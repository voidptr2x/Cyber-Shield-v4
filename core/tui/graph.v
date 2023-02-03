module tui

import os
import time

pub struct Graph
{
	pub mut:
        pack				string
    	graph               string
    	graph_width         int
    	graph_heigth        int
    	num                 int
    	graph_data	    	[]string = [
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.',
			'.'
		]
}

pub fn graph_init__(pack string, h int, w int) Graph
{
	mut g := Graph{}
    g.pack = pack
	g.graph_heigth = h 
    g.graph_width = w
	return g
}

pub fn (mut g Graph) graph_layout() string
{
    return os.read_file("${g.pack}graph.txt") or {
        print("[!] Error - wShSaDA4CSi8, Unable to retrieve graph layout from file....!")
        exit(0)
    }
}

pub fn (mut g Graph) render_graph() string
{
    g.graph = ""
    for line in g.graph_data
    {
        g.graph += "${line}\r\n"
    }
    return g.graph
}

pub fn (mut g Graph) append_to_graph(data int)!
{
    g.num = data
    mut new_data := g.generate_bar(data)
    
    for i in 0..g.graph_heigth
    {
        if g.graph_data[i].len >= g.graph_width { g.graph_data[i] = g.graph_data[i][1..g.graph_width] }

        if i >= (g.graph_heigth - new_data) { g.graph_data[i] += "#" } 
        else { g.graph_data[i] += "." }
    }
}

pub fn (mut g Graph) generate_bar(num int) int
{
    mut bar := 0
	if g.num < 1000 { bar = 1 }
    else if g.num == 1000 { bar = 2 }
	else if g.num > 1000 && g.num < 5000 { bar = 3 }
    else if g.num == 5000 { bar = 4 }
	else if g.num > 5000 && g.num < 10000 { bar = 5 }
    else if g.num == 10000 { bar = 6 }
	else if g.num > 10000 && g.num < 15000 { bar = 7 }
    else if g.num == 15000 { bar = 8 }
	else if g.num > 15000 && g.num < 20000 { bar = 9 }
    else if g.num == 20000 { bar = 10 }
    else if g.num > 20000 && g.num < 25000 { bar = 11 }
    else if g.num == 25000 { bar = 12 }
    else if g.num > 25000 && g.num < 30000 { bar = 13 }
    else if g.num == 30000 { bar = 14 }
    else if g.num > 30000 && g.num < 35000 { bar = 15 }
    else if g.num == 35000 { bar = 16 }
	else if g.num > 35000 && g.num < 40000 { bar = 17 }
	else if g.num == 40000 { bar = 18 }
	else if g.num > 40000 && g.num < 45000 { bar = 19 }
	else if g.num == 45000 { bar = 20 }
	else if g.num > 45000 && g.num < 50000 { bar = 21 }
	else if g.num == 50000 { bar = 22 }
	else if g.num > 50000 { bar = 23 }
    return bar
}