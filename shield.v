import os

import time
import vweb
import core as cs
import core.app_auth
import core.web as w

const help = "[ x ] Error, Invalid argument(s) provided
Usage: ${os.args.clone()[0]} -i <interface> ++
    Tools             Arguments             Description
_____________________________________________________________________
    -l               <licenseID>            Provide a license ID to use this application
    -i               <interface>            Set interface used in monitor
    -mp               <max_pps>             Max PPS you want filtering to start
    -tui                 N/A                Enable TUI mode
    -t               <pack_name>            Name of theme pack
    -web                <port>              Enable web server for info API etc
    -reset               N/A                Enable IPTables Reset After an attack
    -ball                N/A                Block incoming connection access
    -wip                 <ip>               Whitlist IP(s)
    -bip                 <ip>               Block IP(s)
    -quick               <ip>               Get quick raw text information.
               -con                         Display connection info
               -hdw                         Display hardware info
               -os                          Display OS info
    -v                  <file>              Open/View a CyberShield dump file"

fn main() 
{
	args := os.args.clone()
	mut web_port := 0 

	if "-h" in args
	{
		print("${help}\r\n")
		exit(0)
	}

	if args.len < 4 {
		print("[!] Error - LsXr45QHtlFB, Invalid arguments provided\r\nUsage: ${args[0]} -l <license_id> -i <interface>\r\n")
		exit(0)
	}

	mut lic := app_auth.LicenseID{id: args[2]}
	go app_auth.connect_to_backend(mut &lic)
	d := ["/", "|", "\\", "-"]
	mut c := 0
	for timer in 0..30 {
		if lic.tui_status == true { break }

		// print("Loading${d[c]}\r")
		if c == d.len { c = 0}
		c++
		if timer == 20 {
			print("[!] Error, Unable to reach Cyber Shield server....!\n")
			exit(0)
		}

		time.sleep(1*time.second)
	}
	mut cshield := cs.start_session(mut lic)

	for i, arg in args 
	{
		if arg == "-tui" { cshield.ui_mode = true } // UI Mode
		if arg == "-noreset" { cshield.reset = true } // Firewall Reset
		if arg == "-i" { cshield.sys.con.iface = args[i+1] } // Set Interface
		if arg == "-mp" { cshield.sys.con.max_pps = args[i+1].int() }
		if arg == "-web" { web_port = args[i+1].int() }

		/* Optional IPTables Reset After An Attack */
		if arg == "-t" { cshield.set_theme_pack(args[i+1]) }

		if arg == "-quick" {
			if "-con" in args[i..] {
				cshield.sys.con.get_speed()
				print(cshield.sys.con.download)
			}

			if "-hdw" in args[i..] {
				// quick raw text function needed to be called here
			}

			if "-os" in args[i..] {
				// quick raw text function needed to be called here
			}
			exit(0)
		}
	}

	/* Set interface when used */
	if cshield.sys.con.iface == "" { cshield.get_interface() } 
	if cshield.sys.con.iface == "" { exit(0) }

	/*
		Loading Screen 

		Then Run App
	*/

	if web_port != 0 { go vweb.run(&w.App{sys_info: &cshield}, web_port) }
	cs.run_protection(mut &cshield)
}