"use strict";

const request = require('request');
const fs = require('fs');
const path = require('path');

function baixar(ano, mes, callback) {
    let mesString = `${mes < 10 ? '0' : ''}${mes}`;

    let link = `http://arquivos.portaldatransparencia.gov.br/downloads.asp?a=${ano}&m=${mesString}&consulta=Diarias`;

    let caminhoCompletoArquivo = path.resolve(__dirname, '..', 'dados', `${ano}${mesString}_Diarias.zip`);

    console.log(`Baixando ${caminhoCompletoArquivo} de ${link}...`);

    let file = fs.createWriteStream(caminhoCompletoArquivo);
    const req = request.get(link);
    req.pipe(file);
    req.on('end', function () {
        console.log(`Download de ${caminhoCompletoArquivo} concluido!`);
        callback(caminhoCompletoArquivo);
    });
}

module.exports = baixar;