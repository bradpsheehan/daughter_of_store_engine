$(document).ready(function() {
  var $existingPromotionValue = $('#existing-promotion-value').text();       //hackity-hack
  // var $fullPrice = $('#full-price').text();
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
      var $fullPrice = +$('#full-price').text();
      $('#promotion-price').text('Promotional Price: $' + (($fullPrice - (($sliderValue/100) * $fullPrice))).toFixed(2));
    }
  });
  $( "#amount" ).val($( "#slider-range-min" ).slider( "value" ));

  $('#amount').css('width', '50px')
  $('#amount').prepend("<span>$</span>")
  $('#promotion-price').css('margin-top', '10px');

  var $fullPrice = +$('#full-price').text();
  $('#promotion-price').text('Promotional Price: $' + ($fullPrice - (((+$existingPromotionValue/100) * $fullPrice))).toFixed(2));
  $('#amount').keyup(function() {
    var $newPromotionValue = +$(this).val();
    $('#promotion-price').text('Promotional Price: $' + (+$fullPrice - +((($newPromotionValue/100) * $fullPrice))).toFixed(2));
  });
});
// ($newPromotionValue/100) * $fullPrice

//1) make an element in the form with the value and call text here and set value to that...
        //problem-- can't get @product.promotion data to javascript file

