jQuery(function($) {
  $('#payment-form').submit(function(event) {
    var $form = $(this);
    $form.find("input[type='submit']").prop('disabled', true);
    Stripe.card.createToken($form, stripeResponseHandler);
    return false;
  });
});

function stripeResponseHandler(status, response) {
  var $form = $('#payment-form');
  var $paymentContainer = $form.find('.stripe-errors-container')

  if (response.error) {
    $paymentContainer.css('display', 'block');
    $paymentContainer.on('click', function() {
      $(this).css('display', 'none');
    });

    $form.find('.stripe-errors').text(response.error.message);
    $form.find("input[type='submit']").prop('disabled', false);
  } else {
    var token = response.id;
    $form.append($('<input type="hidden" name="stripeToken" />').val(token));
    $form.get(0).submit();
  }
};
