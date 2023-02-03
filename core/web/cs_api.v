module web

import vweb
import core

pub struct App {
    vweb.Context
    pub mut:
        sys_info    core.CyberShield
}


['/']
fn (mut a App) index() vweb.Result {
    a.sys_info.sys.pull_all_info()
    device_info := "Current PPS: ${a.sys_info.sys.con.pps}

OS: ${a.sys_info.sys.os.name}
OS Version: ${a.sys_info.sys.os.version}
Kernel: ${a.sys_info.sys.os.kernel}
Shell: ${a.sys_info.sys.os.shell}

CPU: ${a.sys_info.sys.hdw.cpu_name}
CPU Cores: ${a.sys_info.sys.hdw.cpu_cores}
CPU Usage: ${a.sys_info.sys.hdw.cpu_usage}

Memory Capacity: ${a.sys_info.sys.hdw.memory_capacity}
Memory Used: ${a.sys_info.sys.hdw.memory_used}
Memory Free: ${a.sys_info.sys.hdw.memory_free}
Memory Usage: ${a.sys_info.sys.hdw.memory_used}/${a.sys_info.sys.hdw.memory_capacity}"
    a.text("${device_info}")
	return $vweb.html()
}