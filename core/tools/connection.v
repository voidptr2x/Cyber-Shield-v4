module tools

import os
import time
import core.tui
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

pub struct Netstat {
    pub mut:
        data                string
        cons                []NetStat_Con
        last_data           string

        con_count           string
		ports_used			map[int]int
}

pub struct NetStat_Con {
    pub mut:
        protocol            string
        recv_bytes          int
        sent_bytes          int
        internal_addr       string
        internal_port       int
        incoming_addr       string
        incoming_port       int
        state               string
}

pub fn new_con(p string, rb int, sb int, intl_a string, intl_p int, incg_a string, incg_p int, s string) NetStat_Con
{
    return NetStat_Con{protocol: p,
    recv_bytes: rb,
    sent_bytes: sb,
    internal_addr: intl_a,
    internal_port: intl_p,
    incoming_addr: incg_a,
    incoming_port: incg_p,
    state: s}
}

/*
tcp        0      0 172.20.20.20:46176      142.251.35.162:443      ESTABLISHED
tcp6       0      0 2601:19c:4a08:592:42158 2607:f8b0:4006:80e::443 ESTABLISHED
*/
pub fn get_netstat() Netstat {
    mut n := Netstat{}
    mut con := NetStat_Con{}

    n.data = os.execute("netstat -tn").output
    mut con_arr := n.data.split("\n")
    for _ in 0..2 { con_arr.delete(0) } // Delete top 2 rows of the command before iterating 
    
    for line in con_arr
    {
        info := strip_array(line.split(" "))
        if info.len < 1 { break }
        mut internal_a := info[3]
        mut internal_a_port := 0
        mut incoming_a := info[4]
        mut incoming_a_port := 0

        // IPv4 & IPv6 Checksum
        addr_elements := internal_a.split(":")
        if addr_elements.len == 2 { // Valid IPv4
            if validate_ipv4(addr_elements[0]) {
                internal_a = addr_elements[0]
                internal_a_port = addr_elements[1].int()
            }
        } else if addr_elements.len >= 3 {
            internal_a = info[3].replace(addr_elements[addr_elements.len-1], "")
            internal_a_port = addr_elements[addr_elements.len-1].int()
        }

        addy_elements := incoming_a.split(":")
        if addy_elements.len == 2 { // Valid IPv4
            if validate_ipv4(addy_elements[0]) {
                incoming_a = addy_elements[0]
                incoming_a_port = addy_elements[1].int()
            }
        } else if addy_elements.len >= 3 {
            incoming_a = info[4].replace(addy_elements[addy_elements.len-1], "")
            incoming_a_port = addy_elements[addy_elements.len-1].int()
        }

		
		n.validate_n_add(internal_a_port)
        n.cons << new_con(info[0], info[1].int(), info[2].int(), internal_a, internal_a_port, incoming_a, incoming_a_port, info[5])
    }

    return n
}

pub fn (mut n Netstat) validate_n_add(port int) {
	for k, v in n.ports_used
	{
		if port == k {
			n.ports_used[port]++
		} else {
			n.ports_used[port] = 1
		}
	}
}

pub fn strip_array(a []string) []string {
    mut new := []string{}
    for item in a { if item != "" { new << item }}
    return new
}

pub fn validate_ipv4(ip string) bool
{
    for i in ip.split(".") { if i.int() < 1 || i.int() > 255 { return false } }
    return true
}

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
	go os.execute("speedtest > result.txt")
	for _ in 0..30 // check speedtest results for 30 seconds
	{
		time.sleep(1*time.second) // LOOP IN SECONDS
		speed_data := os.read_file("result.txt") or { "" }
		if speed_data.contains("Upload: ") { // MAKING SURE WE GOT THE LAST LINE SPEEDTEST PROVIDES WHICH MEANS ITS DONE
			for line in speed_data.split("\n")
			{
				if line.starts_with("Download: ") {
					con.download = line.replace("Download:", "").trim_space()
				} else if line.starts_with("Upload: ") {
					con.upload = line.replace("Upload:", "").trim_space()
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