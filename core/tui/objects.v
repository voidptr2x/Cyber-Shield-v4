module tui

import x.json2

pub const config_path = "assets/config.json"
pub const prot_path = "assets/protection.json"

pub const color_codes = {
	'{Bold}': '\x1b[1m',
	'{Reset_Term}': '\x1b[0m',
	'{Reset_Bold}': '\x1b[21m',
	'{Default}': '\x1b[39m',
	'{Black}': '\x1b[30m',
	'{Red}': '\x1b[31m',
	'{Green}': '\x1b[32m',
	'{Yellow}': '\x1b[33m',
	'{Blue}': '\x1b[34m',
	'{Purple}': '\x1b[35m',
	'{Cyan}': '\x1b[36m',
	'{Light_Grey}': '\x1b[37m',
	'{Dark_Grey}': '\x1b[90m',
	'{Light_Red}': '\x1b[91m',
	'{Light_Green}': '\x1b[92m',
	'{Light_Yellow}': '\x1b[93m',
	'{Light_Blue}': '\x1b[94m',
	'{Light_Purple}': '\x1b[95m',
	'{Light_Cyan}': '\x1b[96m',
	'{White}': '\x1b[97m',
	// Background Colors
	'{Default_BG}': '\x1b[49m',
	'{Black_BG}': '\x1b[40m',
	'{Red_BG}': '\x1b[41m',
	'{Green_BG}': '\x1b[42m',
	'{Yellow_BG}': '\x1b[43m',
	'{Blue_BG}': '\x1b[44m',
	'{Purple_BG}': '\x1b[45m',
	'{Cyan_BG}': '\x1b[46m',
	'{Light_Grey_BG}': '\x1b[47m',
	'{Dark_Grey_BG}': '\x1b[100m',
	'{Light_Red_BG}': '\x1b[101m',
	'{Light_Green_BG}': '\x1b[102m',
	'{Light_Yellow_BG}': '\x1b[103m',
	'{Light_Blue_BG}': '\x1b[104m',
	'{Light_Purple_BG}': '\x1b[105m',
	'{Light_Cyan_BG}': '\x1b[106m',
	'{White_BG}': '\x1b[107m',
	'{Clear}': '\033[2J\033[1;1H',
}

pub struct Config {
    pub mut:
        // App Config
        config_data         json2.Any
        protection_data     json2.Any
        // Theme pack shit
		theme_pack_path		string

        // Text Positioning Config File
        text_data           string
        text                json2.Any

        // UI & Graph Data
		ui					string
    	graph_layout        string

		title				string
		description			string
		version				f64

		term				Terminal
		graph 				Graph_Display
		conntable 			Conntable_Display
		os					OS_Display
		hdw					Hardware_Display
		conn 				Connection_Display
}

pub struct Terminal 
{
	pub mut:
		size				[]string
		title				string
		motd				string
}

pub struct Graph_Display
{
	pub mut:
                display				bool
                graph_layout_p		        []string
                graph_p				[]string
                data_c				[]string
}

pub struct Conntable_Display
{
	pub mut:
                display				bool
                border_c			[]string
                text_c				[]string
                header_text_c		        []string
}

pub struct OS_Display
{
	pub mut:
                display			        bool
                labels_c			[]string
                value_c				[]string
                
                os_name_p			[]string
                os_version_p		        []string
                os_kernel_p			[]string
                shell_p				[]string
}

pub struct Hardware_Display
{
	pub mut:
                display				bool
                labels_c			[]string
                value_c				[]string

                cpu_count_p			[]string
                cpu_name_p			[]string
                cpu_cores_p			[]string
                cpu_usage_p			[]string
                cpu_freq_p			[]string
                cpu_arch			[]string

                memory_type_p		        []string
                memory_capacity_p	        []string
                memory_usage_p		        []string
                memory_used_p		        []string
                memory_free_p		        []string

                hdd_name_p			[]string
                hdd_capacity_p		        []string
                hdd_used_p			[]string
                hdd_free_p			[]string
                hdd_usage_p			[]string
}

pub struct Connection_Display
{
	pub mut:
                display				bool
                labels_c			[]string
                value_c				[]string
                system_ip_p			[]string
                socket_ip_p			[]string

                wifi_adapter_p		        []string
                ms_p				[]string
                download_speed_p	        []string
                upload_speed_p		        []string
                nload_stats_p		        []string
        
                pps_p				[]string
}