"use strict";

const lerCSV = require("./ler-csv");
const dezipar = require('./dezipador');
const baixar = require('./baixador');
const acessarBD = require('./conexao-banco');

const ano = 2016;
const mes = 9;

baixar(ano, mes, function (r) {
    dezipar(ano, mes);
    let diarias = lerCSV(ano, mes);
    // console.log(diarias);

    const bd = acessarBD();
    // bd.inserirDiaria(diarias.diarias[0]);
    console.log('Processando diarias...');
    diarias.diarias.forEach(bd.inserirDiaria);
    console.log('PRONTO!');
    bd.fecharConexao();
});
