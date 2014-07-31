// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function () {
	$('input[type=file]').bootstrapFileInput();
	$('.file-inputs').bootstrapFileInput();

   function handleFileSelect(evt) {
	   var files = evt.target.files; // FileList object
	    // Loop through the FileList and render image files as thumbnails.
	   for (var i = 0, f; f = files[i]; i++) {
	      // Only process image files.
	      if (!f.type.match('image.*')) {
	        continue;
	      }
	      var reader = new FileReader();
	      // Closure to capture the file information.
	      reader.onload = (function(theFile) {
	        return function(e) {
	          // Render thumbnail.
	          var span = document.createElement('span');
	          span.innerHTML = ['<img class="thumb" src="', e.target.result,
	                            '" title="', escape(theFile.name), '"/>'].join('');
	          document.getElementById('preview_selfie').innerHTML = ['<span><img class="thumb" src="', e.target.result,
	                            '" title="', escape(theFile.name), '"/></span>'].join('');;
	        };
	      })(f);

	      // Read in the image file as a data URL.
	      reader.readAsDataURL(f);
	    }
	  }

	 document.getElementById('selfie_file').addEventListener('change', handleFileSelect, false);
 
   $('#filter_challenge').click(function() {
	   var search_val = $('#filter_challenge_field').val();
	   if (search_val == '') {
	      search_val = 'emptySelection'
	   };
	   $.ajax({
	      url: '/selfies/filter/' + search_val,
	      type: 'get',
	      dataType: 'script'
	   });
	   return false;  
		});

		$('#filter_challenge_field').keydown(function(e) {
		 if(e.which == 13) {
		   var search_val = $(this).val();
		   if (search_val == '') {
		     search_val = 'emptySelection'
		   };
		   $.ajax({
		       url: '/selfies/filter/' + search_val,
		       type: 'get',
		       dataType: 'script'
		    });
		   return false;    
		 }
	});

	$('#selfie_form').submit(function()
	{			
		if ($(".file-input-name")[0]){	
		   return true;
		} else {
			$('#selfie_alert').html("<i class='fa fa-exclamation-triangle'></i> Please select a file.");
			return false;
		}
	});
});