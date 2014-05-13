$(document).ready(function() {
		
	var video = document.getElementById("mirror-video"),
		canvas = document.getElementById("mirror-canvas"),
		ctx = canvas.getContext('2d')
		
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
			setupFallback()
		});
	} else {
		setupFallback()
	}
	
	function setupFallback() {
		video.src = '/videos/mirror.mp4'
		video.loop = 'loop'
		video.play()
		loop()
	}

	function loop() {
	    ctx.drawImage(video, -65, 0, 410, 150)
	    requestAnimationFrame(loop)
	}
	
	var desaturate = function (ctx) {
		var imgData = ctx.getImageData(0, 0, dimension, dimension);
	
		for (y = 0; y < dimension; y++) {
			for (x = 0; x < dimension; x++) {
				i = (y * dimension + x) * 4;
			
				// Apply Monochrome level across all channels:
				imgData.data[i] = imgData.data[i + 1] = imgData.data[i + 2] = RGBtoGRAYSCALE(imgData.data[i], imgData.data[i + 1], imgData.data[i + 2]);
			}
		}
	
		return imgData;
	};
 
	var RGBtoGRAYSCALE = function (r, g, b) {
		// Returns single monochrome figure:
		return window.parseInt((0.2125 * r) + (0.7154 * g) + (0.0721 * b), 10);
	};

	window.requestAnimationFrame = (function(){
	  return  window.requestAnimationFrame       ||
	          window.webkitRequestAnimationFrame ||
	          window.mozRequestAnimationFrame    ||
	          function( callback ){
	            window.setTimeout(callback, 1000 / 60);
	          };
	})();
		
	
})