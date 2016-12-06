const AdmZip = require('adm-zip');
const path = require('path');

function dezipar(ano, mes) {
    let mesString = `${mes < 10 ? '0' : ''}${mes}`;

    let caminhoCompletoArquivoZip = path.resolve(__dirname, '..', 'dados', `${ano}${mesString}_Diarias.zip`);

    console.log(`Dezipando ${caminhoCompletoArquivoZip}...`);

    let zip = new AdmZip(caminhoCompletoArquivoZip);

    let caminhoDestinoArquivosExtraidos = path.resolve(__dirname, '..', 'dados');
    zip.extractAllTo(caminhoDestinoArquivosExtraidos, true);

    console.log(`Arquivo de ${caminhoCompletoArquivoZip} dezipados em ${caminhoDestinoArquivosExtraidos}!`);
}

module.exports = dezipar;

