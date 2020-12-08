function updateDate(filename) {
    jQuery.get('https://covid19br.github.io/web/' + filename + '.txt', function(readData) {
        // text processing
        dateHourArray = readData.split(" ");
        dateArray = dateHourArray[0].split("-");
        hourArray = dateHourArray[1].split(":");
        $( ".updateDate" ).text("Última atualização: "+hourArray[0]+":"+hourArray[1]+" ⋅ "+dateArray[2]+"/"+dateArray[1]+"/"+dateArray[0]);
    });
}
