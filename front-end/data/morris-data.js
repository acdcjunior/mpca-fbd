$(function() {

    $.getJSON("/valor-por-dia", function (registros) {

        registros.forEach(function (r) {
            r.period = r.dt_diaria.replace('T00:00:00.000Z', '');
            delete r.dt_diaria;
        });

        Morris.Area({
            element: 'morris-area-chart',
            data: registros,
            xkey: 'period',
            ykeys: ['valor'],
            labels: ['Diarias por Dia (R$)'],
            pointSize: 2,
            hideHover: 'auto',
            resize: true
        });
    });

});
