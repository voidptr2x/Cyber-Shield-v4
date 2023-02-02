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
	ut.clear_screen()
	ut.hide_cursor()
	cs.sys.pull_all_info()
	ut.move_cursor(0, 0)
	print(cs.cfg.replace_color_code(cs.cfg.ui))
	mut graph := tui.graph_init__(cs.cfg.theme_pack_path, 23, 65)

	con_info := cs.cfg.retrieve_graph_cfg()
		ut.list_text([(con_info['graph_layout_p'] or { "0" }).arr()[0].int(), (con_info['graph_layout_p'] or { "0" }).arr()[1].int()], "${graph.graph_layout()}")

	/* Display OS Information */ 
	os_info := cs.cfg.retrieve_os_cfg()
	if (os_info['display'] or { return }).bool() == true {
		ut.place_text([(os_info['os_name_p'] or { "0" }).arr()[0].int(), (os_info['os_name_p'] or { "0" }).arr()[1].int()], "${cs.sys.os.name}")
		ut.place_text([(os_info['os_version_p'] or { "0" }).arr()[0].int(), (os_info['os_version_p'] or { "0" }).arr()[1].int()], "${cs.sys.os.version}")
		ut.place_text([(os_info['os_kernel_p'] or { "0" }).arr()[0].int(), (os_info['os_kernel_p'] or { "0" }).arr()[1].int()], "${cs.sys.os.kernel}")
		ut.place_text([(os_info['shell_p'] or { "0" }).arr()[0].int(), (os_info['shell_p'] or { "0" }).arr()[1].int()], "${cs.sys.os.shell}")
	}

	/* Display Hardware Information */
	hdw := cs.cfg.retrieve_hdw_cfg()
	if (hdw['display'] or { return }).bool() == true {
		ut.place_text([(hdw['cpu_name_p'] or { "0" }).arr()[0].int(), (hdw['cpu_name_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.cpu_name[..18]}...")
		ut.place_text([(hdw['cpu_cores_p'] or { "0" }).arr()[0].int(), (hdw['cpu_cores_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.cpu_cores}  ")
		ut.place_text([(hdw['cpu_usage_p'] or { "0" }).arr()[0].int(), (hdw['cpu_usage_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.cpu_usage}  ")
		
		ut.place_text([(hdw['memory_capacity_p'] or { "0" }).arr()[0].int(), (hdw['memory_capacity_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.memory_capacity} GB")
		ut.place_text([(hdw['memory_used_p'] or { "0" }).arr()[0].int(), (hdw['memory_used_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.memory_used} GB")
		ut.place_text([(hdw['memory_free_p'] or { "0" }).arr()[0].int(), (hdw['memory_free_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.memory_free} GB")
		ut.place_text([(hdw['memory_usage_p'] or { "0" }).arr()[0].int(), (hdw['memory_usage_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.memory_used}/${cs.sys.hdw.memory_capacity} GB")
	

		ut.place_text([(hdw['hdd_capacity_p'] or { "0" }).arr()[0].int(), (hdw['hdd_capacity_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.hdd_capacity} GB")
		ut.place_text([(hdw['hdd_used_p'] or { "0" }).arr()[0].int(), (hdw['hdd_used_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.hdd_capacity} GB")
		ut.place_text([(hdw['hdd_free_p'] or { "0" }).arr()[0].int(), (hdw['hdd_free_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.hdd_capacity} GB")
	}
	mut c := 0
	for {
		cs.sys.pull_all_info()
		if c >= 1000 { // 1 sec delay
			graph.append_to_graph(cs.sys.con.pps) or { return }
			ut.list_text([11, 40], graph.render_graph())
			ut.place_text([6, 89], "      ")
			ut.place_text([6, 89], "${cs.sys.con.pps}")
			c = 0
		} else if c >= 60000 { go c.get_speed() } // every 30 sec call speedtest
		
		c++
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
		time.sleep(1*time.second)
	}
}

pub fn run(mut c tl.Connection) {
	for {
		c.get_pps()
	}
}