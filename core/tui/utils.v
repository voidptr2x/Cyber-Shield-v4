module tui

pub fn (mut c Config) replace_color_code(text string) string
{
	mut new := text
	for key, val in color_codes
	{
		if new.contains(key)
		{
			new = new.replace(key, val)
		}
	}
	return new
}