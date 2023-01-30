module core

import os
import time
import core.tui
import core.utils as ut
import core.tools as tl

pub struct CyberShield 
{
	pub mut:
		reset		bool	/* IPTables Reset Toggle */
		ui_mode		bool	/* Enable CyberShield's TUI */
		tick		int
		sys 		tl.System
		cfg			tui.Config
}

pub fn start_session() CyberShield
{
	mut cs := CyberShield{sys: tl.System{con: tl.Connection{}, hdw: tl.Hardware{}, os: tl.OS{}}}
	return cs
}

pub fn (mut cs CyberShield) set_theme_pack(pack_name string) {
	cs.cfg = tui.retrieve_theme_pack(pack_name)
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
		print("[ X ] Error - IFPqD3GvECyG, Invalid value provided! Exiting....\r\n")
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
	print(cs.cfg.ui)

	/* Display OS Information */ 
	os_info := cs.cfg.retrieve_os_cfg()
	cs.sys.os.update_os()
	if (os_info['display'] or { return }).bool() == true {
		ut.place_text([(os_info['os_name_p'] or { return }).arr()[0].int(), (os_info['os_name_p'] or { return }).arr()[1].int()], "${cs.sys.os.name}")
		ut.place_text([(os_info['os_version_p'] or { return }).arr()[0].int(), (os_info['os_version_p'] or { return }).arr()[1].int()], "${cs.sys.os.version}")
		ut.place_text([(os_info['os_kernel_p'] or { return }).arr()[0].int(), (os_info['os_kernel_p'] or { return }).arr()[1].int()], "${cs.sys.os.kernel}")
		ut.place_text([(os_info['shell_p'] or { return }).arr()[0].int(), (os_info['shell_p'] or { return }).arr()[1].int()], "${cs.sys.os.shell}")
	}

	hdw := cs.cfg.retrieve_hdw_cfg()
	cs.sys.hdw.update_hdw()
	if (hdw['display'] or { return }).bool() == true {
		ut.place_text([(hdw['cpu_name_p'] or { return }).arr()[0].int(), (hdw['cpu_name_p'] or { return }).arr()[1].int()], "${cs.sys.hdw.cpu_name[..20]}...")
	}

	for {
		ut.place_text([7, 89], "${cs.sys.con.pps}")
		// ut.place_text([13, 9], "PPS: ${cs.sys.con.pps}")
		// ut.place_text([14, 9], "CPU Usage: ${cs.sys.hdw.cpu_usage}")
		time.sleep(10*time.millisecond)
		ut.place_text([7, 89], "      ")
	}
}

pub fn run_protection(mut cs CyberShield)
{
	go run(mut &cs.sys.con)
	if cs.ui_mode { go cs.run_monitor() }
	for {
		if cs.sys.con.max_pps > cs.sys.con.pps {
			// stsart getting information about connections here
		}
		cs.tick++
	}
}

pub fn run(mut c tl.Connection) {
	for {
		c.get_pps()
	}
}