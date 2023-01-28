module tools

import os
import time

const packet_path = "/sys/class/net/{interface}/statistics/{mode}_packets"

pub struct Connection
{
	pub mut:
		iface		string
		rx			int
		tx 			int

		pps			int
		upload		string
		download	string
		ms			int
}


pub fn (mut con Connection) get_speed()
{
	mut c := Connection{}
	go os.execute("speedtest > result.txt")
	for _ in 0..30 // check speedtest results for 30 seconds
	{
		time.sleep(time.second*1) // LOOP IN SECONDS
		speed_data := os.read_file("result.txt") or { "" }
		if speed_data.contains("Upload: ") { // MAKING SURE WE GOT THE LAST LINE SPEEDTEST PROVIDES WHICH MEANS ITS DONE
			for line in speed_data.split("\n")
			{
				if line.starts_with("Download: ") {
					c.download = line.replace("Download:", "").trim_space()
					print("Download Speed Updated: ${c.download}\r\n")
				} else if line.starts_with("Upload: ") {
					c.upload = line.replace("Upload:", "").trim_space()
					print("Upload Speed Updated: ${c.upload}\r\n")
				}
			}
			os.execute("rm -rf result.txt")
			return // NO NEED TO CONTINUE THE LOOP
		}
	}
}

pub fn (mut con Connection) get_pps() Connection
{
	rx_path := packet_path.replace("{interface}", con.iface).replace("{mode}", "rx")
	tx_path := packet_path.replace("{interface}", con.iface).replace("{mode}", "tx")

	rx := (os.read_file(rx_path) or { "" }).int()
	tx := (os.read_file(tx_path) or { "" }).int()

	time.sleep(time.second*1)

	new_rx := (os.read_file(rx_path) or { "" }).int()
	new_tx := (os.read_file(tx_path) or { "" }).int()

	con.pps = (tx - new_tx) - (rx - new_rx)
	return con
}