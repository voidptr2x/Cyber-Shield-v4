module core

import os
import time
import core.utils as ut
import core.tools as tl

pub struct CyberShield 
{
	pub mut:
		reset		bool	/* IPTables Reset Toggle */
		ui_mode		bool	/* Enable CyberShield's TUI */
		sys 		tl.System
		cfg			Config
}

pub fn start_session() CyberShield
{
	mut cs := CyberShield{sys: tl.System{con: tl.Connection{}, hdw: tl.Hardware{}, os: tl.OS{}}}
	return cs
}

pub fn (mut cs CyberShield) set_theme_pack(pack_name string) {
	cs.cfg = Config{theme_pack_path: pack_name}
}

pub fn (mut cs CyberShield) set_interface(ifc string) { cs.sys.con.iface = ifc }
pub fn (mut cs CyberShield) set_ui_mode(ui_mode bool)  { cs.ui_mode = ui_mode }

pub fn (mut cs CyberShield) get_interface() 
{
	interfaces := cs.get_all_interfaces()
	iface := os.input("${interfaces}\r\nSelect an interface (0-${interfaces.len-1}): ")

	// Add INTERGER VALIDATION BELOW
	if iface == ""
	{
		print("[ X ] Error, Invalid value provided! Exiting....\r\n")
		exit(0)
	}
	cs.sys.con.iface = interfaces[iface.int()]
}

pub fn (mut cs CyberShield) get_all_interfaces() []string 
{
	mut interfaces := []string{}
	ifcfg := os.execute("ifconfig").output
	for line in ifcfg.split("\n")
	{
		if line.starts_with(" ") == false {
			interfaces << line.split(":")[0]
		}
	}
	return ut.remove_empty_elements(interfaces)
}

pub fn (mut cs CyberShield) run_monitor() 
{
	ut.hide_cursor()
	print((os.read_file("assets/themes/builtin/ui.txt") or {""}))
	ut.place_text([13, 9], "PPS: ${cs.sys.con.pps}")

	for {

		ut.place_text([13, 9], "PPS: ${cs.sys.con.pps}")

		time.sleep(1*time.second)

		ut.place_text([13, 9], "        ")
	}
}

pub fn (mut cs CyberShield) run_protection()
{
	if cs.ui_mode { go cs.run_monitor() }
	for {
		con := cs.sys.con.get_pps()
		if cs.sys.con.max_pps > con.pps {
			// stsart getting information about connections here
		}
	}
}