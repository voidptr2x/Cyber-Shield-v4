module utils

pub fn set_term_size(h int, w int) {
	print("\x1b[8;${h};${w}t")
}

pub fn move_cursor(r int, c int) {
	print("\033[${r};${c}f")
}

pub fn clear_screen() {
	print("\x1b[2J")
}

pub fn hide_cursor() {
	print("\033[?25l")
}

pub fn show_cursor() {
	print("\033[?25h")
}

pub fn place_text(p []int, t string) {
	print("\x1b[${p[0]};${p[1]}f${t}")
}

pub fn place_color_text(p []int, c []int, t string) {
	print("\x1b[${p[0]};${p[1]}f\x1b[38;2;${c[0]};${c[1]};${c[2]}m${t}")
}

pub fn list_text(p []int, t string) {
	mut row := p[0]
	for line in t.split("\n") {
		print("\x1b[${row};${p[1]}f${line}")
		row++
	}
}

pub fn list_color_text(p []int, c []int, t string) {
	mut row := p[0]
	for line in t.split("\n") {
		place_color_text([row, p[1]], c, line)
		row++
	}
}

