/**
 * @author mbalach
 */

$(document).ready(function() {
    /* flash notice slide up animation */
    window.setTimeout("$(\"#flash\").slideUp('slow')",2500);

    $.ajaxSetup({  
        'beforeSend': function (xhr) {xhr.setRequestHeader("Accept", "text/javascript")}  
    }); 


    /* Site header links */
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
    
    $(".offer").bind("click", function() {
        $("#offer_dialog").dialog({ modal: true,
                                    width: '400px',
                                    height: '400',
                                    title: 'Create your Offer',
                                    position: 'center',
                                    resizable: false,
                                    draggable: false,
                                    closeOnEscape: true,
                                    buttons: { 
                                        "Cancel": function() { $(this).dialog("close"); },
                                        "Create Offer": function() {
                                            $("#offer_form").submit()
                                        }
                                    }
                                  });
        return false;
    });

    $(".addtocart").bind("click", function() {
        $('#cart_dialog').empty();
        $.get($(this).attr('href'),null,null,'script');
        $("#cart_dialog").dialog({ modal: true,
                                    width: '600px',
                                    height: '400',
                                    title: 'Your Cart Items..',
                                    position: 'center',
                                    resizable: false,
                                    draggable: false,
                                    closeOnEscape: true,
                                    buttons: { 
                                        "Continue Shopping...": function() { $(this).dialog("close"); },
                                        "Checkout Now!": function() {
                                            $("#offer_form").submit()
                                        }
                                    }
                                  });
        return false;
    });


    $("#offer_form").bind("submit",function(){
        $.post($(this).attr('action'),$(this).serialize(),null,'script');
        return false;
    });

    /* date picker */
    $(".date_available").datepicker();
    
    /* add images */
    $("#add_image").bind("click", function() {  
        var rand = Math.random().toString().split(".")[1];
        var input = '<input type="file" name="product[image_attributes][][uploaded_data]" size="30" class="formField" />'	
        $(this).before('<br/>' + input );
    });
    $("#add_image").trigger("click");     	    	
});
