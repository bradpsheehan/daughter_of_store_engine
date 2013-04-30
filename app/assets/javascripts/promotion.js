$(document).ready(function() {
  var $existingPromotionValue = $('#existing-promotion-value').text();       //hackity-hack
  $('#existing-promotion-value').css('opacity', 0);                        //hackity-hack
  $('#full-price').css('opacity', 0);                                     //hackity-hack

  $( "#slider-range-min" ).slider({
    range: "min",
    value: $existingPromotionValue,
    min: 0,
    max: 100,
    slide: function( event, ui ) {
      $( "#amount" ).val( ui.value );
      var $sliderValue = +$('#amount').val();
      var $fullPrice = +$('#product_price').val();
      $('#promotion-price').text('Promotional Price: $' + (($fullPrice - (($sliderValue/100) * $fullPrice))).toFixed(2));
    }
  });
  $( "#amount" ).val($( "#slider-range-min" ).slider( "value" ));

  $('#amount').css('width', '50px')
  $('#amount').prepend("<span>$</span>")

  var $fullPrice = +$('#full-price').text();
  $('#promotion-price').text('Promotional Price: $' + ($fullPrice - (((+$existingPromotionValue/100) * $fullPrice))).toFixed(2));

  $('#amount').keyup(function() {
    var $newPromotionValue = +$(this).val();
    var $fullPrice = +$('#product_price').val();
    var $amt = $(this).val()
    $('#slider-range-min').slider('value', $amt);
    $('#promotion-price').text('Promotional Price: $' + ($fullPrice - +((($newPromotionValue/100) * $fullPrice))).toFixed(2));
    if(+$('#amount').val() > 100) {
      $('#promotion-price').text('Promotional Price: $0');
      $('#amount').val(100);
      alert("Promotion value cannot exceed 100%")
    }
    if(isNaN($('#amount').val())) {
      $('#amount').val(0);
      alert('Numbers only, please')
    }
  });

  $('#product_price').keyup(function() {
    var $newPromotionValue = +$("#amount").val();
    var $newProductPrice = +$(this).val();
    $('#promotion-price').text('Promotional Price: $' + ($newProductPrice - +((($newPromotionValue/100) * $newProductPrice))).toFixed(2));
  });

  $('#promotion-price').addClass('strokememore')

  $('#a').css('float', 'left')
  $('#b').css('float', 'left')
  $('#b').css('margin-left', '22px')
  $('#b').css('margin-top', '29px')

  $('#column-two').css('clear', 'left');
  $('#column-two').css('float', 'left');

  $('#d').css('position', 'relative')
  $('#d').css('margin-top', '33px')
  $('#d').css('left', '112px')
  $('#c').css('float', 'left')

  $('.control-group.radio_buttons.required.product_status').css('clear', 'left');
});
