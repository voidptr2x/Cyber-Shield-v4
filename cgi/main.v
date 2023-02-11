import os

fn main() {
	if os.exists("shield.v") != true {
		print("[!] Error, File not found\n")
		exit(0)
	}

	go os.execute("v shield.v -o shield_glib_2.35_x86_64 -prod > ci_results.txt")

	for {
		mut file_data := os.read_file("ci_results.txt") or {
			println("[!] Error, Unable to read results")
			exit(0)
		}
	}
}