import os

fn main() {

    mut conn_list := map[string][]string{}
    connections := os.execute("netstat -tn").output
    mut con_arr := connections.split("\n")
    con_arr.delete(0) // Deleting extra netstat -tn BS 
    con_arr.delete(0) 
    for line in con_arr
    {
        info := strip_array(line.split(" "))
        if info.len < 1 { break }
        conn_list[info[4]] = [info[0], info[3].split(":")[info[3].split(":").len-1], info[1], info[2], info[5]]
    }

    for key, value in conn_list 
    {
        print("${key}: ${value}\n")
    }
}

fn strip_array(a []string) []string {
    mut new := []string{}
    for item in a { if item != "" { new << item }}
    return new
}
