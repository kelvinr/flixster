$(function($) {
  var $form = $(document.getElementById("payment-form"));
  $form.submit(function(event) {
    $form.find('button').prop('disabled', true);
    Stripe.card.createToken($form, stripeResponseHandler);
    return false;
  });

  function stripeResponseHandler(status, response) {
    if (response.error) {
      var fields = $form.find(".credit_card .form-group")
      var fieldCount = fields.length
      var msg = response.error.message

      for (i=0; i < fieldCount; i++) {
        var field = document.getElementById(fields[i].id);
        if (new RegExp(field.id).test(msg) && field.lastChild.nodeName != "SPAN") {
          var span = document.createElement("SPAN");
          var errorMsg = document.createTextNode(msg);
          span.appendChild(errorMsg);
          field.appendChild(span);
          field.className += " error";
        }
      }
    } else {
    var token = response.id;
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    $form.get(0).submit();
    }
  }
});
