jQuery.get('https://raw.githubusercontent.com/badain/covid19br.github.io/master/graphs/dataehora.txt', function(readData) {
    dateHourArray = readData.split(" ");
    dateArray = dateHourArray[0].split("-");
    hourArray = dateHourArray[1].split(":");
    $( ".updateDate" ).append(hourArray[0]+":"+hourArray[1]+" ⋅ "+dateArray[2]+"/"+dateArray[1]+"/"+dateArray[0]);
 });