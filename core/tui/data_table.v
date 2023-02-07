module tui

pub const (
	UpperLeft_Corner = "╔"
	UpperRight_Corner = "╗"

	MiddleLine = "═"
	MiddleDownLine = "╦"
	MiddleUpLine = "╩"
	MiddleEdge = "║"
	Cross = "╬"
	LeftLineLeft = "╠"
	RightLineRight = "╣"

	BottomLeft_Corner = "╚"
	BottomRight_Corner = "╝"
)

pub struct Table {
	pub mut:
		/* 
			use this field to set the length
			of each column!
		*/
		columns		[]int
		table		string
}

pub fn (mut t Table) create_table_title(title string) {
	mut first_line := UpperLeft_Corner
	mut header_row := MiddleEdge + " ${title}"
	mut last_line := BottomLeft_Corner

	title_len := title.len
	mut spaces_left := 0
	for _, i in t.columns {
		spaces_left += i
		first_line += MiddleLine + t.fill_line(i+1)
		last_line += t.fill_line(i+2)
	}

	for _ in 0..(spaces_left-title_len)+6 {
		header_row += " "
	}

	header_row += MiddleEdge
	first_line += UpperRight_Corner
	last_line += BottomRight_Corner

	t.table += first_line.replace("═╗", "╗") + "\r\n" + header_row + "\r\n" + last_line.replace("═╝", "╝") + "\r\n"
}

pub fn create_table(cols []int) Table {
	mut t := Table{columns: cols}
	return t
}

pub fn (mut t Table) fit_text(text string, length int) string {
	spaces_left := length-text.len
	mut td := " ${text}"
	for _ in 0..spaces_left {
		td += " "
	}
	return td
}

pub fn (mut t Table) fill_column(length int) string {
	mut line := ""
	for _ in 0..length {
		line += " "
	}
	return line
}

pub fn (mut t Table) fill_line(length int) string {
	mut line := ""
	for _ in 0..length {
		line += "═"
	}
	return line
}

pub fn (mut t Table) create_header(cols []string) {
	mut first_line := UpperLeft_Corner
	mut header_row := MiddleEdge
	mut last_line := LeftLineLeft

	for count, i in t.columns {
		first_line += MiddleLine + t.fill_line(i)
		header_row += t.fit_text(cols[count], i)
		last_line += t.fill_line(i+1) + Cross
		first_line += MiddleDownLine
		header_row += MiddleEdge
	}
	first_line += UpperRight_Corner
	last_line += RightLineRight

	t.table += first_line.replace("╦╗", "╗") + "\r\n" + header_row + "\r\n" + last_line.replace("╬╣", "╣") + "\r\n"
}

pub fn (mut t Table) add_row(row_cols []string) {
	mut row := MiddleEdge

	for count, i in row_cols {
		row += t.fit_text(i, t.columns[count]) + MiddleEdge
	}

	t.table += row.replace("║╣", "╣") + "\r\n"
}

pub fn (mut t Table) add_separator() {
	mut row := LeftLineLeft

	for i in t.columns {
		row += t.fill_line(i+1) + Cross
	}
	row += RightLineRight

	t.table += row.replace("╬╣", "╣") + "\r\n"
}

pub fn (mut t Table) create_footer() {
	mut row := BottomLeft_Corner

	for i in t.columns {
		row += t.fill_line(i+1) + MiddleUpLine
	}

	row += BottomRight_Corner

	t.table += row.replace("╩╝", "╝") + "\r\n"
}

pub fn (mut t Table) fetch_table() string {
	return t.table
}