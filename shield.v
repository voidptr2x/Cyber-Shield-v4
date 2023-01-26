import os

import core as cs
import core.tools as info

const help = "[ x ] Error, Invalid argument(s) provided
    Tools              Description
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
	args := os.args.clone()

	if "-h" in args
	{
		print("${help}\r\n")
		exit(0)
	}

	for i, arg in args 
	{
		/* Set Interface if flag is used*/
		if arg == "-i" { cshield.iface = args[i+1] } // Interface || -i eth0

		/* Optional IPTables Reset After An Attack */
		if arg == "-t" { // IPTables Reset || -t 0
			if args[i+1].int() == 0 && args[i+1] != "0" { cshield.reset = false }
			else if args[i+1].int() == 1 { cshield.reset = true }
		}

		/*
			Quick Use Of This Application ('-quick' flag)
			-con
			-hdw
			-os (SOON)
		*/
		if arg == "-quick" {

			// if "-con" in args[i..] {
			// 	c.get_pps()
			// 	print("PPS: ${c.pps}\r\n")
			// 	c.get_speed()
			// }

			if "-hdw" in args[i..] {
				mut hdw := info.retrieve_hardware()
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

	/* Set infterface when used */
	if cshield.iface == "" { cshield.get_interface() } else { exit(0) }

	/*
		Loading Screen 

		Then Run App
	*/
}