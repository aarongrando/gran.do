$.fn.Url = function() {

	if ($(this).length > 0) {
		var url_step = 0,
			url_to_build = "for-the-love-of-the-url",
			base_url_fragments = document.URL.split('/'),
			base_url_path = '/' + base_url_fragments[base_url_fragments.length - 2] + '/'

		history.pushState(null, null, base_url_path)
		var whoa_interval = setInterval(growURL, 30)
	}
	
	function growURL() {
		if (_.last(document.URL.split('/')).length < url_to_build.length) {
			history.replaceState(null, null, base_url_path + url_to_build.substring(0,url_step))
			url_step++;
		} else {
			clearInterval(whoa_interval)
		}
	}
}