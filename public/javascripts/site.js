/**
 * @author mbalach
 */
$(document).ready(function() {
	/*
	 * 	 Site header links 
	 */
  $("#login").bind("click", function() {	  
  	$("#login_dialog").dialog({ modal: true,
	title: 'Sign In Here...',
	position: 'top',
	resizable: false,
	draggable: false,
	closeOnEscape: true,
	buttons: { 
	"Cancel": function() { $(this).dialog("close"); },
	"Login": function() { $("#login_form").submit(); } 
	}});		
	return false;
  });
  $("#signup").bind("click", function() {	    		
	$("#signup_dialog").dialog({ modal: true,
	title: 'Sign Up Here...',
	position: 'top',
	resizable: false,
	draggable: false,
	closeOnEscape: true,
	buttons: { 
	"Cancel": function() { $(this).dialog("close"); },
	"Signup": function() { $("#signup_form").submit(); } 
	}});			
	return false;
  }); 
  
  /* date picker */
  $("#date_available").datepicker();
  
  /* add images */
  $("#add_image").bind("click", function() {  
    var rand = Math.random().toString().split(".")[1];
    var input = '<input type="file" name="product[image_attributes][][uploaded_data]" size="30" class="formField" />'	
    $(this).before('<br/>' + input );
  });
  $("#add_image").trigger("click");
     	    	
});
