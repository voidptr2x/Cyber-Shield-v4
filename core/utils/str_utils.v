module utils

pub fn remove_empty_elements(arr []string) []string {
	mut new_arr := []string{}

	for _, element in arr {
		if element.trim_space() != "" { new_arr << element }
	}
	return new_arr
}