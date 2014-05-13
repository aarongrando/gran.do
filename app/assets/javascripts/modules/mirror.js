$.fn.MirrorVideo = function() {
	
	var $video = $('#mirror-video')

	if ($video.length > 0) {	
		var video = document.getElementById("mirror-video"),
			canvas = document.getElementById("mirror-canvas"),
			ctx = canvas.getContext('2d')

		init_video()
	}
	
	function init_video() {
		navigator.getUserMedia = navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia
		window.URL = window.URL || window.webkitURL || window.mozURL || window.msUR
	
		video.volume = 0
	
		if (typeof navigator.getUserMedia != 'undefined') {
			navigator.getUserMedia({
			    video: true,
				audio: false
			}, function (stream) {
			    video.src = window.URL.createObjectURL(stream)
				video.play()
			    loop()
			}, function() {
				setup_fallback()
			});
		} else {
			setup_fallback()
		}
	}

	function setup_fallback() {
		video.src = '/videos/mirror.mp4'
		video.loop = 'loop'
		video.play()
		loop()
	}

	function loop() {
		try {
	    	ctx.drawImage(video, -65, 0, 410, 150)
	    } catch (e) {
			if (e.name == "NS_ERROR_NOT_AVAILABLE") {
				setTimeout(loop, 0);
			} else {
				throw e;
			}
		}
		requestAnimationFrame(loop)
	}

	window.requestAnimationFrame = (function(){
	  return  window.requestAnimationFrame       ||
	          window.webkitRequestAnimationFrame ||
	          window.mozRequestAnimationFrame    ||
	          function( callback ){
	            window.setTimeout(callback, 1000 / 60)
	          }
	})()
}