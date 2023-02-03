module tools

import os
import time
import net.http as web

const packet_path = "/sys/class/net/{interface}/statistics/{mode}_packets"

pub struct Connection
{
	pub mut:
		iface		string
		rx			int
		tx 			int

		system_ip	string
		max_pps		int
		pps			int
		upload		string
		download	string
		ms			int
}


/*

    def get_sys_ip(self) -> str:
        ip_a = subprocess.getoutput("ip a")
        sys_ip = ""
        iface_found = False
        
        for line in ip_a.split("\n"):
                if self.interface in line: iface_found = True
                if iface_found:
                        if line.strip().startswith('inet '):
                                sys_ip = line.strip().split(" ")[1].split("/")[0]
                                break
        if sys_ip: return sys_ip
        return requests.get("https://api.ipify.org").text
*/
pub fn (mut con Connection) get_system_ip() {
	ip_a := os.execute("ip a").output
	mut sys_ip := ""
	mut iface_found := false 

	for line in ip_a.split("\n")
	{
		if line.contains(con.iface) { iface_found = true }
		if iface_found 
		{
			if line.trim_space().starts_with("inet ")
			{
				sys_ip = line.trim_space().split(" ")[1].split("/")[0]
				break
			}
		}
	}
	if sys_ip != "" { con.system_ip = sys_ip }
	con.system_ip = web.get_text("https://api.ipify.org")
}


pub fn (mut con Connection) get_speed()
{
	mut c := Connection{}
	go os.execute("speedtest > result.txt")
	for _ in 0..30 // check speedtest results for 30 seconds
	{
		time.sleep(500*time.millisecond) // LOOP IN SECONDS
		speed_data := os.read_file("result.txt") or { "" }
		if speed_data.contains("Upload: ") { // MAKING SURE WE GOT THE LAST LINE SPEEDTEST PROVIDES WHICH MEANS ITS DONE
			for line in speed_data.split("\n")
			{
				if line.starts_with("Download: ") {
					c.download = line.replace("Download:", "").trim_space()
				} else if line.starts_with("Upload: ") {
					c.upload = line.replace("Upload:", "").trim_space()
				}
			}
			os.execute("rm -rf result.txt")
			return// NO NEED TO CONTINUE THE LOOP
		}
	}
}

pub fn (mut con Connection) get_pps() Connection
{
	rx_path := packet_path.replace("{interface}", con.iface).replace("{mode}", "rx")
	tx_path := packet_path.replace("{interface}", con.iface).replace("{mode}", "tx")

	rx := (os.read_file(rx_path) or { "" }).int()
	tx := (os.read_file(tx_path) or { "" }).int()

	time.sleep(1*time.second)

	new_rx := (os.read_file(rx_path) or { "" }).int()
	new_tx := (os.read_file(tx_path) or { "" }).int()

	con.pps = (tx - new_tx) - (rx - new_rx)
	return con
}