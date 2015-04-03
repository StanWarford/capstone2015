$(document).on('pagebeforeshow', '#index', function(){
	// Add a new input element
	$('[data-role=footer]').append('<input type="range" name="slider-2" id="slider-2" value="25" min="0" max="100"  />');
	$('[class=ui-field-contain]').append('<span class="flipperBrowse"><select id="flip2" data-role="slider" data-mini="true"><option value="off">Off</option><option value="on">On</option></select></span>');
	$('#index').trigger('create');
});