import vweb

struct App {
    vweb.Context
}

fn main() {
    vweb.run(&App{}, 8080)
}

['/']
fn (mut a App) index() vweb.Result {
    a.text("gang")
	return $vweb.html()
}
