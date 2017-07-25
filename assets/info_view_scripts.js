function is_touch_device() {
 return (('ontouchstart' in window)
      || (navigator.MaxTouchPoints > 0)
      || (navigator.msMaxTouchPoints > 0));
}
selectEvent = "touchstart"
if (!is_touch_device()) {
	selectEvent = "click"
}

tocHeadingTap = function(e) {
	selectedEl = e.target;
	containingElement = selectedEl.parentElement.parentElement.classList.toggle("showInfo");
	e.preventDefault();
	
	/*
	tocLinks = document.body.querySelectorAll("#toc .header a");
	for (var i = 0; i < tocLinks.length; i++) {
		l = tocLinks[i];
		if (l != selectedEl) {
			l.parentElement.parentElement.classList.remove("showInfo");
		}			
	}
	*/
}

tocLinks = document.body.querySelectorAll("#toc .header a");
for (var i = 0; i < tocLinks.length; i++) {
	l = tocLinks[i];
	l.addEventListener(selectEvent, tocHeadingTap, false);				

}

