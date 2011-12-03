var bookmarklet = document.getElementById('bookmarklet');
if (bookmarklet) {
	bookmarklet.addEventListener('click', function(e) {
		alert('Drag this to your bookmarks bar to install.');
		e.preventDefault();
	}, false);	
}
