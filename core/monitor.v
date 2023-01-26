module core

import os
import core.utils as ut

pub struct CyberShield {
	pub mut:
		iface 		string
		reset		bool
}

pub fn (mut cs CyberShield) set_iface(ifc string) {
	cs.iface = ifc
}

pub fn (mut cs CyberShield) get_interface() {
	interfaces := cs.get_all_interfaces()
	iface := os.input("${interfaces}\r\nSelect an interface (0-${interfaces.len-1}): ")
	if iface == ""
	{
		print("[ X ] Error, Invalid value provided! Exiting....\r\n")
		exit(0)
	}
}

pub fn (mut cs CyberShield) get_all_interfaces() []string {
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

pub fn start_session() CyberShield
{
	mut cs := CyberShield{}
	return cs
}