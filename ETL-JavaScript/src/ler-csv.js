"use strict";

const readFile = require("./read-file");
const path = require('path');
const Diaria = require('./diaria');

function lerCSV(ano, mes) {
    let mesString = `${mes < 10 ? '0' : ''}${mes}`;

    let caminhoCompletoArquivoCsv = path.resolve(__dirname, '..', 'dados', `${ano}${mesString}_Diarias.csv`);

    const contents = readFile(caminhoCompletoArquivoCsv, 'ISO-8859-1');
    const linhasComoString = contents.split('\r\n');

    const primeiraLinha = linhasComoString.shift();

    return {
        cabecalho: separarColunas(primeiraLinha),
        diarias: linhasComoString.map(linhaString => new Diaria(linhaString))
    };
}

function separarColunas(linha) {
    return linha.split('\t');
}

module.exports = lerCSV;