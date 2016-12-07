"use strict";

const request = require('request');
const fs = require('fs');
const path = require('path');

function baixar(ano, mes, callback) {
    let mesString = `${mes < 10 ? '0' : ''}${mes}`;

    let link = `http://arquivos.portaldatransparencia.gov.br/downloads.asp?a=${ano}&m=${mesString}&consulta=Diarias`;
    // let link = `https://github.com/acdcjunior/mpca-fbd-diarias/raw/master/${ano}${mesString}.zip`;

    let caminhoCompletoArquivo = path.resolve(__dirname, '..', 'dados', `${ano}${mesString}_Diarias.zip`);

    console.log(`Baixando ${caminhoCompletoArquivo} de ${link}...`);

    let file = fs.createWriteStream(caminhoCompletoArquivo);
    const req = request.get(link);
    req.pipe(file).on('close', function () {
        console.log(`Download de ${caminhoCompletoArquivo} concluido!`);
        callback(caminhoCompletoArquivo);
    });
}

module.exports = baixar;