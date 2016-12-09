"use strict";

const iconvlite = require('iconv-lite');
const fs = require('fs');
const path = require('path');
const Diaria = require('./diaria');

function lerCSV(ano, mes) {
    let mesString = `${mes < 10 ? '0' : ''}${mes}`;

    let caminhoCompletoArquivoCsv = path.resolve(__dirname, '..', 'dados', `${ano}${mesString}_Diarias.csv`);

    const contents = readFileSync_encoding(caminhoCompletoArquivoCsv, 'ISO-8859-1');
    const linhasComoString = contents.split('\r\n');

    const primeiraLinha = linhasComoString.shift();

    linhasComoString.pop(); // remover linha sumario "Detalhamento das informações não disponível." + Total de valores

    return {
        cabecalho: separarColunas(primeiraLinha),
        diarias: linhasComoString.map(linhaString => new Diaria(linhaString))
    };
}

function separarColunas(linha) {
    return linha.split('\t');
}

function readFileSync_encoding(filename, encoding) {
    let content = fs.readFileSync(filename);
    return iconvlite.decode(content, encoding);
}

module.exports = lerCSV;