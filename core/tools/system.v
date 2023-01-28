module tools

pub struct System
{
	pub mut:
		con			Connection
		os			OS
		hdw			Hardware
		ui_mode		bool
}

pub fn start_session() System
{
	mut s := System{con: Connection{}, os: OS{}, hdw: Hardware{}}
	go run_pps(s.con)
	return s
}