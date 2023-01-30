module tools

import os

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
	h.cpu_usage = (os.execute('top -bn1 | sed -n \'/Cpu/p\' | awk \'{print $2}\' | sed \'s/..,//\'').output).f64()
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

//         def retrieveHDD(self) -> Hardware_Info:
//                 self.info.hdd_capacity = round(self.hdd_info.total / (2**30))
//                 self.info.hdd_used = round(self.hdd_info.used / (2**30))
//                 self.info.hdd_free = round(self.hdd_info.free / (2**30))

//                 return self.info
pub fn (mut h Hardware) retrieve_hdd()
{
	
}