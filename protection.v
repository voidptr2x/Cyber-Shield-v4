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
    mut t := tui.create_table([6, 4, 4, 18, 2, 18, 2, 13])
    t.create_table_title("Netstat -tn Alternative")
    n := tl.get_netstat()
    t.create_footer()
    for con in n.cons {
        t.add_row([con.protocol, "${con.recv_bytes}", "${con.sent_bytes}", con.internal_addr, "${con.internal_port}", con.incoming_addr, "${con.incoming_port}", con.state])
        if con != n.cons[n.cons.len-1] { t.add_separator() }
        for k, v in protected_ports
        {
            check := n.ports_used[k.int()] or { 0 }
            if k.int() > check
            {
                print("[!] Detecting suspecious traffic.....\n")
            }
        }
    }
    t.create_footer()
    print(t.fetch_table())
}