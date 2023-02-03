module tools

pub struct System
{
	pub mut:
		con			Connection
		os			OS
		hdw			Hardware
		ui_mode		bool
}

pub fn (mut s System) pull_all_info() 
{
	s.os.update_os()
	s.hdw.update_hdw()
	s.con.get_system_ip()
}