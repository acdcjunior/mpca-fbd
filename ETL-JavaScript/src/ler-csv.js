"use strict";

const iconvlite = require('iconv-lite');
const fs = require('fs');
const path = require('path');
const Diaria = require('./diaria');

function lerCSV(ano, mes) {
    let mesString = `${mes < 10 ? '0' : ''}${mes}`;

    let caminhoCompletoArquivoCsv = path.resolve(__dirname, '..', 'dados', `${ano}${mesString}_Diarias.csv`);

    const contents = readFileSync_encoding(caminhoCompletoArquivoCsv, 'ISO-8859-1');
    let linhasComoString = contents.split('\r\n');

    const primeiraLinha = linhasComoString.shift();

    linhasComoString.pop(); // remover linha sumario "Detalhamento das informações não disponível." + Total de valores

    let diarias = linhasComoString.map(linhaString => new Diaria(linhaString));

    // remover linha sumario "Detalhamento das informacoes na disponivel."
    diarias = diarias.filter(diaria => diaria.doc.indexOf(`Detalhamento`) === -1);

    return {
        cabecalho: separarColunas(primeiraLinha),
        diarias: diarias
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