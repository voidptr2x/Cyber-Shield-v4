module core

import os
import core.utils as ut
import core.tools as tl

pub struct CyberShield 
{
	pub mut:
		iface 		string  /* Interface */
		reset		bool	/* IPTables Reset Toggle */
		ui_mode		bool	/* Enable CyberShield's TUI */
		sys 		tl.System
}

pub fn start_session() CyberShield
{
	mut cs := CyberShield{sys: tl.System{}}
	return cs
}

pub fn (mut cs CyberShield) set_interface(ifc string) { cs.iface = ifc }
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
	cs.iface = interfaces[iface.int()]
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
	print((os.read_file("assets/ui.txt") or {""}))
	for {

	}
}

pub fn (mut cs CyberShield) run_protection()
{
	if cs.ui_mode { go cs.run_monitor() }
	for {

	}
}