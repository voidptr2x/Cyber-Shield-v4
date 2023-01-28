import os

import core as cs
import core.tui

const help = "[ x ] Error, Invalid argument(s) provided
Usage: ${os.args.clone()[0]} -i <interface> ++
    Tools              Description
_____________________________________________
    -i              Set interface used in monitor
                    Flag(s): <interface>
    -tui            Enable TUI mode
    -noreset        Disable IPTables Reset After an attack
    -ball           Block incoming connection access
    -wip            Whitlist an IP Address
                    Flag(s): <ip>
    -bip            Manually block an IP
    				Flag(s): <ip>
    -quick          Get quick raw text information.
       Flag(s):
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
	if "-tui" in args { cshield.ui_mode = true } // UI Mode
	if "-noreset" in args { cshield.reset = true } // Firewall Reset

	for i, arg in args 
	{
		if arg == "-i" { cshield.set_interface(args[i+1]) } // Set Interface

		/* Optional IPTables Reset After An Attack */
		if arg == "-t" { if args[i+1].int() == 1 { cshield.reset = true } }

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
	if cshield.iface == "" { cshield.get_interface() } 
	if cshield.iface == "" { exit(0) }

	/*
		Loading Screen 

		Then Run App
	*/

	cshield.run_protection()
}