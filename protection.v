import os

import core.tui

pub struct Netstat {
    pub mut:
        data                string
        cons                []NetStat_Con
        last_data           string

        con_count           string
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

fn main() {
    mut t := tui.create_table([6, 4, 4, 20, 20, 13])
    t.create_table_title("Netstat -tn Alternative")
    n := get_netstat()
    t.create_footer()
    for con in n.cons {
        t.add_row([con.protocol, "${con.recv_bytes}", "${con.sent_bytes}", con.internal_addr, con.incoming_addr, con.state])
        if con != n.cons[n.cons.len-1] { t.add_separator() }

    }
    t.create_footer()
    print(t.fetch_table())
}

fn filter() 
{

}

/*
tcp        0      0 172.20.20.20:46176      142.251.35.162:443      ESTABLISHED
tcp6       0      0 2601:19c:4a08:592:42158 2607:f8b0:4006:80e::443 ESTABLISHED
*/
fn get_netstat() Netstat {
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
        n.cons << new_con(info[0], info[1].int(), info[2].int(), internal_a, internal_a_port, incoming_a, incoming_a_port, info[5])
    }

    return n
}

fn strip_array(a []string) []string {
    mut new := []string{}
    for item in a { if item != "" { new << item }}
    return new
}

fn validate_ipv4(ip string) bool
{
    for i in ip.split(".") { if i.int() < 1 || i.int() > 255 { return false } }
    return true
}
