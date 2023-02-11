module core

import os
import time
import core.tui
import core.app_auth
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
		cs_server	app_auth.LicenseID
}

pub fn start_session(mut lic app_auth.LicenseID) CyberShield
{
	mut cs := CyberShield{sys: tl.System{con: tl.Connection{}, hdw: tl.Hardware{}, os: tl.OS{}}, cs_server: lic}
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
	if cs.cs_server.tui_status == false { 
		print("[!] Error, You are not able to use this feature. Message owner for details...\n")
		return 
	}

	ut.clear_screen()
	ut.hide_cursor()
	cs.sys.pull_all_info()
	ut.move_cursor(0, 0)

	/* Display main UI and Set up Graph Size */
	print(cs.cfg.replace_color_code(cs.cfg.ui))
	mut graph := tui.graph_init__(cs.cfg.theme_pack_path, 23, 65)

	/* Call all screen configuration information */
	graphcfg := cs.cfg.retrieve_graph_cfg()
	os_info := cs.cfg.retrieve_os_cfg()
	hdw := cs.cfg.retrieve_hdw_cfg()
	con := cs.cfg.retrieve_conn_cfg()
	sz := cs.cfg.retrieve_term_cfg()

	/* Set Terminal Size */
	ut.set_term_size((sz['size'] or { 0 }).arr()[0].int(), (sz['size'] or { 0 }).arr()[1].int())

	/* Display Graph Layout*/
	if (graphcfg['display'] or { panic("[!] Error, Graph Display boolean")}).bool() == true {
		ut.list_text([(graphcfg['graph_layout_p'] or { panic("[!] Error, Graph layout position 1") }).arr()[0].int(), (graphcfg['graph_layout_p'] or { panic("[!] Error, Graph layout position 2") }).arr()[1].int()], "${graph.graph_layout()}")
	}

	/* Display OS Information */
	if (os_info['display'] or { return }).bool() == true {
		ut.place_text([(os_info['os_name_p'] or { panic("[!] Error, OS name position") }).arr()[0].int(), (os_info['os_name_p'] or { panic("[!] Error, OS name position") }).arr()[1].int()], "${cs.sys.os.name}")
		ut.place_text([(os_info['os_version_p'] or { panic("[!] Error, OS version position") }).arr()[0].int(), (os_info['os_version_p'] or { panic("[!] Error, OS version position") }).arr()[1].int()], "${cs.sys.os.version}")
		ut.place_text([(os_info['os_kernel_p'] or { panic("[!] Error, OS kernel position") }).arr()[0].int(), (os_info['os_kernel_p'] or { panic("[!] Error, OS kernel position") }).arr()[1].int()], "${cs.sys.os.kernel}")
		ut.place_text([(os_info['shell_p'] or { panic("[!] Error, Shell position") }).arr()[0].int(), (os_info['shell_p'] or { panic("[!] Error, Shell position") }).arr()[1].int()], "${cs.sys.os.shell}")
	}

	/* Display Hardware Information */
	if (hdw['display'] or { return }).bool() == true {
		ut.place_text([(hdw['cpu_name_p'] or { panic("[!] Error, CPU name position") }).arr()[0].int(), (hdw['cpu_name_p'] or { panic("[!] Error, CPU name position") }).arr()[1].int()], "${cs.sys.hdw.cpu_name[0..18]}...")
		ut.place_text([(hdw['cpu_cores_p'] or { panic("[!] Error, CPU cores position") }).arr()[0].int(), (hdw['cpu_cores_p'] or { panic("[!] Error, CPU cores position") }).arr()[1].int()], "${cs.sys.hdw.cpu_cores}  ")
		ut.place_text([(hdw['cpu_usage_p'] or { panic("[!] Error, CPU usage position") }).arr()[0].int(), (hdw['cpu_usage_p'] or { panic("[!] Error, CPU usage position") }).arr()[1].int()], "${cs.sys.hdw.cpu_usage}  ")
		
		ut.place_text([(hdw['memory_capacity_p'] or { panic("[!] Error, Memory capacity position") }).arr()[0].int(), (hdw['memory_capacity_p'] or { panic("[!] Error, Memory capacity position") }).arr()[1].int()], "${cs.sys.hdw.memory_capacity} GB")
		ut.place_text([(hdw['memory_used_p'] or { panic("[!] Error, Memory used positoin") }).arr()[0].int(), (hdw['memory_used_p'] or { panic("[!] Error, Memory used positoin") }).arr()[1].int()], "${cs.sys.hdw.memory_used} GB")
		ut.place_text([(hdw['memory_free_p'] or { panic("[!] Error, Memory free position") }).arr()[0].int(), (hdw['memory_free_p'] or { panic("[!] Error, Memory free position") }).arr()[1].int()], "${cs.sys.hdw.memory_free} GB")
		ut.place_text([(hdw['memory_usage_p'] or { panic("[!] Error, Memory usage position") }).arr()[0].int(), (hdw['memory_usage_p'] or { panic("[!] Error, Memory usage position") }).arr()[1].int()], "${cs.sys.hdw.memory_used}/${cs.sys.hdw.memory_capacity} GB")
	

		// ut.place_text([(hdw['hdd_capacity_p'] or { "0" }).arr()[0].int(), (hdw['hdd_capacity_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.hdd_capacity} GB")
		// ut.place_text([(hdw['hdd_used_p'] or { "0" }).arr()[0].int(), (hdw['hdd_used_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.hdd_capacity} GB")
		// ut.place_text([(hdw['hdd_free_p'] or { "0" }).arr()[0].int(), (hdw['hdd_free_p'] or { "0" }).arr()[1].int()], "${cs.sys.hdw.hdd_capacity} GB")
	}

	/* Display Hardware Information */
	if (con['display'] or { panic("[!] Error, Display use boolean")}).bool() == true { 
		ut.place_text([(con['interface_p'] or { panic("[!] Error, Interface position") }).arr()[0].int(), (con['interface_p'] or { panic("[!] Error, Interface position") }).arr()[1].int()], "${cs.sys.con.iface}")
		ut.place_text([(con['system_ip_p'] or { panic("[!] Error, System IP position") }).arr()[0].int(), (con['system_ip_p'] or { panic("[!] Error, System IP position") }).arr()[1].int()], "${cs.sys.con.system_ip}")
	}


	go trigger_speed(mut &cs.sys.con)
	for {
		graph_c := (graphcfg['data_c'] or { panic("[!] Error, Data Color") }).arr()
		
		graph.append_to_graph(cs.sys.con.pps) or { return } 
		ut.list_text([(graphcfg['graph_p'] or { "0"}).arr()[0].int(), (graphcfg['graph_p'] or { "0"}).arr()[1].int()], cs.cfg.replace_color_code(graph.render_graph().replace("#", "\x1b[38;2;${graph_c[0]};${graph_c[1]};${graph_c[2]}m#{Reset_Term}")))

		ut.place_text([(con['pps_p'] or { "0" }).arr()[0].int(), (con['pps_p'] or { "0" }).arr()[1].int()], "      ")
		ut.place_text([(con['pps_p'] or { "0" }).arr()[0].int(), (con['pps_p'] or { "0" }).arr()[1].int()], "${cs.sys.con.pps}")

		ut.place_text([(con['download_speed_p'] or { "0" }).arr()[0].int(), (con['download_speed_p'] or { "0" }).arr()[1].int()], "${cs.sys.con.download}")
		ut.place_text([(con['upload_speed_p'] or { "0" }).arr()[0].int(), (con['upload_speed_p'] or { "0" }).arr()[1].int()], "${cs.sys.con.upload}")

		time.sleep(1*time.second)
	}
}

pub fn run_protection(mut cs CyberShield)
{
	// go run(mut &cs.sys.con)
	if cs.ui_mode { go cs.run_monitor() }
	for {
		if cs.sys.con.max_pps > cs.sys.con.pps {
			// stsart getting information about connections here
		}
		cs.tick++
		cs.sys.con.get_pps()
	}
}

fn trigger_speed(mut c tl.Connection) {
	c.get_speed()
}