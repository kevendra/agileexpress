$(document).ready(function() {
  // $("#main").height($(window).height() - 280);

//   $('#colorSelector').ColorPicker({
//      color: '#0000ff',
//      onShow: function (colpkr) {
//         $(colpkr).fadeIn(500);
//         return false;
//      },
//      onHide: function (colpkr) {
//         $(colpkr).fadeOut(500);
//         return false;
//      },
//      onChange: function (hsb, hex, rgb) {
//         $('#colorSelector div').css('backgroundColor', '#' + hex);
//      }
//   });

   //   $('#colour').ColorPicker({
   //      onSubmit: function(hsb, hex, rgb, el) {
   //         $(el).val(hex);
   //         $(el).ColorPickerHide();
   //      },
   //      onBeforeShow: function () {
   //         $(this).ColorPickerSetColor(this.value);
   //      }
   //   }).bind('keyup', function() {
   //      $(this).ColorPickerSetColor(this.value);
   //   });

});

function validate() {
   var result = true;
   var pwd = $('#password').val();
   var confirm = $('#confirm').val();
   var hint = $('#passwordHint').val();
   var email = $('#email').val();
   var filter = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
   clearErrors();
   if (!filter.test(email)) {
      $("<label class='error' for='email'>Invalid email</label>").insertAfter("#email");
      result = false;
   }
   if (pwd == "") {
      $("<label class='error' for='password'>Password required</label>").insertAfter("#password");
      result = false;
   }
   if (pwd != confirm) {
      $("<label class='error' for='confirm'>Password and confirmation do not match</label>").insertAfter("#confirm");
      result = false;
   }
   if (hint == "") {
      $("<label class='error' for='passwordHint'>Password hint required</label>").insertAfter("#passwordHint");
      result = false;
   }
   return result;
}

function reset() {
   $("#user").resetForm();
   clearErrors();
   return false;
}

function clearErrors() {
   $("#email + label").remove();
   $("#password + label").remove();
   $("#confirm + label").remove();
   $("#passwordHint + label").remove();
}