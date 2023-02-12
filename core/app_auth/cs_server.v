module app_auth

import io
import net
import time
import x.json2 as j
import core.utils

pub struct LicenseID {
	pub mut: 
		auth_status			bool
		id					string
		username			string // username == discord tag
		discord_id			string
		tui_status			bool
		protection_status	bool
}

const app_version = "cs_4.0.0"
const cs_backend = "192.99.152.130"

pub fn connect_to_backend(mut lic LicenseID) LicenseID {
	mut socket := net.dial_tcp("${cs_backend}:17234") or {
		print("[!] Error, Unable to connect to Cyber Shield Server. Cannot authenticate license ID!....\n")
		exit(0)
	}

	mut reader := io.new_buffered_reader(reader: socket)
	
	socket.write_string("${app_version}\n") or {
		print("[!] Error, Unable to interact with Cyber Shield server...!\n")
		exit(0)
	}
	
	socket.write_string("${lic.id}\n") or { exit(0) }
	data := reader.read_line() or { exit(0) }
	socket.set_read_timeout(time.infinite)

	if data.starts_with("{") && data.ends_with("}") { //validating json format
		user_info := (j.raw_decode(data) or { map[string]j.Any{} }).as_map()
		lic.auth_status = (user_info['status'] or { panic("[!] Error, Status")}).bool()
		lic.username = (user_info['discord_tag'] or { panic("[!] Error, User Discord Tag")}).str()
		lic.discord_id = (user_info['discord_id'] or { panic("[!] Error, User Discord ID") }).str()
		lic.tui_status = (user_info['tui_status'] or { panic("[!] Error, TUI Status")}).bool()
		lic.protection_status = (user_info['protection_status'] or { panic("[!] Error, Protection Status")}).bool()
	}
	
	go connection(mut &lic, mut socket, mut reader)
	return lic
}

pub fn connection(mut lid LicenseID, mut socket net.TcpConn, mut reader io.BufferedReader) {
	for {
		data := reader.read_line() or { "" }
		if data.len > 0 {
			if data == "close" { 
				utils.clear_screen()
				print("[!] Error, The owner has disconnected you from using Cyber Shield....\n")
				exit(0)
			} else if data == "banned" {
				utils.clear_screen()
				print("[!] Error, You have been banned from using Cyber Shield....")
				exit(0)
				// write code here to delete this app from the user's system
			}
		}
	}
}