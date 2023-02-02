import os

import core as cs

const help = "[ x ] Error, Invalid argument(s) provided
Usage: ${os.args.clone()[0]} -i <interface> ++
    Tools             Arguments             Description
_____________________________________________________________________
    -i               <interface>            Set interface used in monitor
    -mp               <max_pps>             Max PPS you want filtering to start
    -tui                 N/A                Enable TUI mode
    -t               <pack_name>            Name of theme pack
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
	mut cshield := cs.start_session()
	args := os.args.clone()

	if "-h" in args
	{
		print("${help}\r\n")
		exit(0)
	}

	for i, arg in args 
	{
		if arg == "-tui" { cshield.ui_mode = true } // UI Mode
		if arg == "-noreset" { cshield.reset = true } // Firewall Reset
		if arg == "-i" { cshield.sys.con.iface = args[i+1] } // Set Interface
		if arg == "-mp" { cshield.sys.con.max_pps = args[i+1].int() }

		/* Optional IPTables Reset After An Attack */
		if arg == "-t" { cshield.set_theme_pack(args[i+1]) }

		if arg == "-quick" {
			if "-con" in args[i..] {
				// quick raw text function needed to be called here
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
	cs.run_protection(mut &cshield)
}