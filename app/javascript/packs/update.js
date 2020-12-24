$(".ajax-input").on("change",function(){
  var product_id = $(this).parent().find('.p-id')[0].value;
  var quantity = $(this).val();
  $.ajax({
    type: "PATCH",
    url: `/carts/${product_id}`,
    dataType: 'script',
    data: { quantity: quantity , product_id: product_id}
  });
});
