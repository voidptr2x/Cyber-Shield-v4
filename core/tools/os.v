module tools

import os

/*
	TO-DO:
		retrieve_kernel()
*/
pub struct OS
{
	pub mut:
		name		string
		kernel		string
		version 	string
		shell		string
}

pub fn (mut o OS) parse_os()
{
	os_info := os.read_file("/etc/os-release") or { "" }
	for line in os_info.split("\n")
	{
		if line.starts_with("NAME=\"") { o.name = line.replace("NAME=\"", "").replace("\"", "") }
		if line.starts_with("VERSION_ID=\"") { o.version = line.replace("VERSION_ID=\"", "").replace("\"", "") }
	}
}

pub fn (mut o OS) retrieve_kernel()
{

}

pub fn (mut o OS) retrieve_shell()
{
	o.shell = os.environ()['SHELL']
}