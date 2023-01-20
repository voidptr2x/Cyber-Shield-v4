import os

import core as cs
import core.tools as info

const help = "    Tools              Description
_____________________________________________
    -i              Set interface used in monitor
    -quick          Get quick raw text information.
        -con        Display connection info
        -hdw        Display hardware info
        -os         Display OS info

    -v              Open/View a CyberShield dump file"

fn main() 
{
	mut cshield := cs.start_session()
	mut c := info.start_connection_info("wlo1")
	mut hdw := info.retrieve_hardware()
	args := os.args.clone()
[]]
	if args.len < 2
	{
		print("[ X ] Error, Invalid argument provided\r\nUse flag '-h' for help!\r\n")
		exit(0)
	}

	if args[1] == "-h"
	{
		print("${help}\r\n")
		exit(0)
	}

	for i, arg in args 
	{
		
		if arg == "-i" { cshield.iface = args[i+1] } // Interface || -i eth0

		if arg == "-t" { // IPTables Reset || -t 0
			if args[i+1].int() == 0 { cshield.reset = false }
			else if args[i+1].int() == 1 { cshield.reset = true }
		}
		if arg == "-quick" {

			if "-con" in args[i..] {
				c.get_pps()
				print("PPS: ${c.pps}\r\n")
				c.get_speed()
			}

			if "-hdw" in args[i..] {
				hdw.retrieve_info()
				print("CPU: ${hdw.cpu_name}\r\n")
				print("CPU Cores: ${hdw.cpu_cores}\r\n")
				print("CPU Usage: ${hdw.cpu_usage}%\r\n")

				print("Memory Capacity: ${hdw.memory_capacity} GB\r\n")
				print("Memory Free: ${hdw.memory_free} GB\r\n")
				print("Memory Usage: ${hdw.memory_used}/${hdw.memory_capacity} GB\r\n")
			}
			exit(0)
		}
	}

	if cshield.iface == "" { cshield.get_interface() }
}