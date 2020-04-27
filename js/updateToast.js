$(document).ready(function(){
    $("#toast-grafico").toast({
      autohide: true,
      delay: 5000
    });
    setTimeout(function () {
      $("#toast-grafico").toast("show");
    }, "1500");
});