import os

pub struct Netstat 
{
    
}

fn main() {
    print(get_netstat())
}

fn get_netstat() map[string][]string {

    mut conn_list := map[string][]string{}
    connections := os.execute("netstat -tn").output
    mut con_arr := connections.split("\n")
    for _ in 0..1 { con_arr.delete(0) }
    
    for line in con_arr
    {
        info := strip_array(line.split(" "))
        if info.len < 1 { break }
        conn_list[info[4]] = [info[0], info[3].split(":")[info[3].split(":").len-1], info[1], info[2], info[5]]
    }

    return conn_list
}

fn strip_array(a []string) []string {
    mut new := []string{}
    for item in a { if item != "" { new << item }}
    return new
}
