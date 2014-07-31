// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
 
if (window.location.hash && window.location.hash == '#_=_') {
  if (window.history && history.pushState) {
      window.history.pushState("", document.title, window.location.pathname);
  } else {
      // Prevent scrolling by storing the page's current scroll offset
      var scroll = {
          top: document.body.scrollTop,
          left: document.body.scrollLeft
      };
      window.location.hash = '';
      // Restore the scroll offset, should be flicker free
      document.body.scrollTop = scroll.top;
      document.body.scrollLeft = scroll.left;
  }
}

$(function () {
	// Ajax Form - Create a Comment to a Selfie
	$('.selfie_post_comment_textarea').keydown(function(e) {		 
		if(e.which == 13 && !e.shiftKey) {
			if ($.trim($(this).val())) {
			 	var form = $(this).parents('form:first');
				var mytextarea = $(this);

			   $.ajax({
		         type: "POST",
		         url: form.attr("action"),
		         data: form.serialize(),
		         dataType: 'script',	
		         success: function(response){
		         	mytextarea.val('');
		         }
		      });
		   }				   
		   return false;				
	   } 
	});

	// Edit Selfie Description
	$('.edit_selfie_message').click(function () {
		var selfie_id = $(this).attr("id");
		$(".selfie_form_" + selfie_id).removeClass("hidden");
		$('.selfie_post_message_' + selfie_id).addClass("hidden");

		return false;
	});

	// Ajax Form - Update Selfie Description
	$('.edit_selfie_form').keydown(function(e) {
		if(e.which == 13 && !e.shiftKey) {
		 	var form = $(this).parents('form:first');
		 				
			$.ajax({
	         type: "PUT",
	         url: form.attr("action"),
	         data: form.serialize(),
	         dataType: 'script'		         
	      }); 			 	
		 	return false;
		}
	});
});
