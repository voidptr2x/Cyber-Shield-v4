module tools

import os

#include <sys/statvfs.h>

fn C.statvfs(const_path &char, buf &C.statvfs) int

struct C.statvfs {
    f_frsize    u64
    f_blocks    u64
    f_bfree     u64
    f_bavail    u64
}

/*
	TO-DO:
		retrieve_hdd()
*/
pub struct Hardware
{
	pub mut:
		cpu_cores		int
		cpu_name		string
		cpu_usage		f64

		memory_type		string
		memory_capacity	int
		memory_used		int
		memory_free		int

		gpu_name		string
		gpu_cores		int
		gpu_freq		int
		gpu_usage		f64

		hdd_name		string
		hdd_capacity	int
		hdd_used		int
		hdd_free		int
		hdd_usage		int
}

pub fn retrieve_hardware() Hardware 
{
	mut h := Hardware{}
	h.update_hdw()
	return h
}

pub fn (mut h Hardware) update_hdw() Hardware
{
	h.parse_cpu()
	h.parse_mem()
	h.retrieve_hdd()
	return h
}

pub fn (mut h Hardware) parse_cpu() 
{
	cpu_info := os.read_file("/proc/cpuinfo") or { "" }
	for line in cpu_info.split("\n")
	{
		if line.starts_with("cpu cores") { h.cpu_cores = line.replace("cpu cores", "").replace(":", "").trim_space().int() } 
		if line.starts_with("model name") { h.cpu_name = line.replace("model name", "").replace(":", "").trim_space() }
	}

	cpu_usg_info := os.read_file("/proc/stat") or { "" }
	cpu_usr_info := cpu_usg_info.split("\n")[0]

	usr := "${cpu_usg_info[0]}".int()
    nce := "${cpu_usg_info[1]}".int()
    system := "${cpu_usg_info[2]}".int()
    idle := "${cpu_usg_info[3]}".int()
    iowait := "${cpu_usg_info[4]}".int()
    irq := "${cpu_usg_info[5]}".int()
    softirq := "${cpu_usg_info[6]}".int()
    steal := "${cpu_usg_info[7]}".int()
    guest := "${cpu_usg_info[8]}".int()
    guest_nice := "${cpu_usg_info[9]}".int()

	mut total := usr + nce + system + idle + iowait + irq + softirq + steal + guest + guest_nice
	h.cpu_usage = 100 * (total - idle - iowait) / total
}

pub fn (mut h Hardware) parse_mem()
{
	mem_info := os.read_file("/proc/meminfo") or { "" }
	for line in mem_info.split("\n")
	{
		if line.starts_with("MemTotal:") {
			h.memory_capacity = line.replace("MemTotal:", "").replace("kB", "").trim_space().int() / 1000000
		}
		if line.starts_with("MemFree:") {
			h.memory_free = line.replace("MemFree:", "").replace("kB", "").trim_space().int() / 1000000
		}
	}
	h.memory_used = h.memory_capacity - h.memory_free
}

pub fn (mut h Hardware) retrieve_hdd()
{
    buf := C.statvfs{}
    C.statvfs(c'/', &buf)
    h.hdd_capacity = "${buf.f_frsize * buf.f_blocks}".int() / 1024
    h.hdd_free = "${buf.f_frsize * buf.f_bfree}".int() / 1024
    mut available_space := buf.f_frsize * buf.f_bavail
	h.hdd_used = "${h.hdd_capacity - h.hdd_free}".int() / 1024
}