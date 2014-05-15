$.fn.Url = function() {

	if ($(this).length > 0) {
		history.pushState(null, null, '/blog/')
		var whoa_interval = setInterval(growURL, 30),
			url_step = 0,
			url_to_build = "for-the-love-of-the-url"
	}
	
	function growURL() {
		if (_.last(document.URL.split('/')).length < url_to_build.length) {
			history.replaceState(null, null, '/blog/' + url_to_build.substring(0,url_step))
			url_step++;
		} else {
			clearInterval(whoa_interval)
		}
	}
	
}