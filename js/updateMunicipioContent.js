// updates date and hour
updateDate("last.update.municipio");

// updates content
const regex = /"/gi;

$.get('https://raw.githubusercontent.com/covid19br/covid19br.github.io/webdesign/web/data_forecasr_exp_municipios.csv', function (raw_data) {
    // data processing
    full_data = raw_data.split("\n");
    current_data = full_data[0].replace(regex, '').split(" ");
    full_text = $(".csv").html();
    new_text = full_text.replace("$min", current_data[1]).replace("$max", current_data[2]).replace("$data", current_data[3]);
    $(".csv").html(new_text);
});