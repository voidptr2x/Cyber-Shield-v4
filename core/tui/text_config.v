module tui

import x.json2

pub struct Config {
	pub mut:
		theme_pack_path		string
		config_path			string
		ui_path				string
		graph_path			string

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
        graph_layout_p		[]string
        graph_p				[]string
        data_c				[]string
        attacked_data_c		[]string
        border_c			[]string
}

pub struct Conntable_Display
{
	pub mut:
        display				bool
        border_c			[]string
        text_c				[]string
        header_text_c		[]string
}

pub struct OS_Display
{
	pub mut:
		display				bool
        labels_c			[]string
        value_c				[]string
	
        os_name_p			[]string
        os_version_p		[]string
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

        memory_type_p		[]string
        memory_capacity_p	[]string
        memory_usage_p		[]string
        memory_used_p		[]string
        memory_free_p		[]string

        hdd_name_p			[]string
        hdd_capacity_p		[]string
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

        wifi_adapter_p		[]string
        ms_p				[]string
        download_speed_p	[]string
        upload_speed_p		[]string
        nload_stats_p		[]string
    
        pps_p				[]string
}

pub fn fetch_config() Config
{
	mut c := Config{}
	return c
}