var initTinyMCE = function(id){
	// Remove any old tinymce instance with this id (e.g. in AJAX context)
	tinymce.remove(id);

        tinymce.init({
                selector: id,
		height: 500,
		width: 700,
		menubar: false,
		toolbar: 'undo redo | insert | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image',
		plugins: [
			'advlist autolink lists link image charmap print preview anchor',
			'searchreplace visualblocks code fullscreen',
			'insertdatetime media table contextmenu paste code'
		],
        });
};

// For multiple fields
function initMultipleTinyMCEs(basename) {
	for( var i = 1; i <= document.getElementById(basename + '_spaces').value; i++ ) {
		initTinyMCE('#' + basename + '_' + i);
	}
}
