const lerCSV = require("./ler-csv");
const dezipar = require('./dezipador');
const baixar = require('./baixador');
const acessarBD = require('./conexao-banco');

const ano = 2016;
const mes = 10;

baixar(ano, mes, function (r) {
    dezipar(ano, mes);
    let diarias = lerCSV(ano, mes);
    console.log(diarias);

    // const bd = acessarBD();
    // diarias.diarias.forEach(bd.inserirDiaria);
    // bd.fecharConexao();
});
