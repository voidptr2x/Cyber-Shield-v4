import os

import core.tui
import core.tools as tl

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
    mut c := tui.retrieve_theme_pack("new")
    protected_ips := c.retrieve_prot_ips_config()
    protected_ports := c.retrieve_prot_ports_config()
    mut t := tui.create_table([6, 4, 4, 18, 6, 18, 6, 13])
    t.create_table_title("Netstat -tn Alternative")
    t.create_header(["Type", "Recv", "Sent", "External IP", "Port", "IP Connected", "Port", "STATE"])
    mut n := tl.get_netstat()
    t.create_footer()
    mut loop_c := 0
    for con in n.cons { // iterating connections from 'netstat -tn'
        t.add_row([con.protocol, "${con.recv_bytes}", "${con.sent_bytes}", con.internal_addr, "${con.internal_port}", con.incoming_addr, "${con.incoming_port}", con.state])
        if con != n.cons[n.cons.len-1] { t.add_separator() }
        for k, v in protected_ports // iterating max cons per port from config file'
        {
            check := n.ports_used[k.int()] or { 0 }
            if k.int() > check // check to see if we went over the max conn per port (Config file settings)
            {
                if con.incoming_addr !in protected_ips { // Making sure we dont end up blocking legit traffic connections (Config file settings)
                    print("[!] Detecting suspecious traffic. Blocking ${con.incoming_addr}.....\n") 
                    os.execute("sudo iptables -I INPUT -s ${con.incoming_addr} -j DROP; sudo iptables -I OUTPUT -s ${con.incoming_addr} -j DROP; sudo iptables-save")
                }
            }
        }
        if loop_c == n.cons.len { os.execute("fuser -k ${n.get_abused_port()}/tcp; fuser -k ${n.get_abused_port()}/udp") }
        if loop_c == n.cons.len && n.get_abused_port() == 22 { os.execute("sudo service ssh retstart")}
        loop_c++
    }
    t.create_footer()
    print(t.fetch_table())
}