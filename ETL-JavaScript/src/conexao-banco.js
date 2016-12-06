const mysql = require('mysql');

function acessarBD() {
    const connection = mysql.createConnection({
        host: 'localhost',
        user: 'acdcjunior',
        password: '',
        database: 'diarias'
    });

    connection.connect();
    connection.query('USE diarias');

    return {
        debug: function () {
            connection.query('SELECT 1 + 1 AS solution', function (err, rows, fields) {
                if (err) throw err;

                console.log('The solution is: ', rows[0].solution);
            });
        },
        fecharConexao: () => connection.end(),

        inserirDiaria: function (diaria) {
            /*
             IN cd_org_sup INT, IN nm_org_sup VARCHAR(200), IN cd_org_sub INT, IN nm_org_sub VARCHAR(200), IN cd_un_gest INT, IN nm_un_gest VARCHAR(200),
             IN cd_funcao INT, IN nm_funcao VARCHAR(200), IN cd_subfuncao INT, IN nm_subfuncao VARCHAR(200), IN cd_prog INT, IN nm_prog VARCHAR(200), IN cd_acao INT, IN nm_acao VARCHAR(200),
             IN ling_cidada VARCHAR(200), IN cpf_fav VARCHAR(11), IN nm_fav VARCHAR(300), IN doc VARCHAR(15), IN gestao VARCHAR(11), IN dt DATE, IN val DECIMAL(10,2)
             */
            let parametros = `
             ${convInt(diaria.cd_org_sup)}, ${convString(diaria.nm_org_sup)}, 
             ${convInt(diaria.cd_org_sub)}, ${convString(diaria.nm_org_sub)}, 
             ${convInt(diaria.cd_un_gest)}, ${convString(diaria.nm_un_gest)},
             ${convInt(diaria.cd_funcao)}, ${convString(diaria.nm_funcao)},
             ${convInt(diaria.cd_subfuncao)}, ${convString(diaria.nm_subfuncao)},
             ${convInt(diaria.cd_prog)}, ${convString(diaria.nm_prog)},
             ${convInt(diaria.cd_acao)}, ${convString(diaria.nm_acao)},
             ${convString(diaria.ling_cidada)},
             ${convString(diaria.cpf_fav)}, ${convString(diaria.nm_fav)},
             ${convString(diaria.doc)}, ${convString(diaria.gestao)}, ${convData(diaria.dt)}, ${convDecimal(diaria.val)}`;

            connection.query("CALL inserir_diaria(" + parametros + ")", function (err, results, fields) {
                if (err) {
                    console.log("ERR veio!");
                    throw new Error(err);
                } else if (results[0].res === 0) {
                    console.log("RESULT deu zero!");
                    throw new Error("Erro! " + err + '-' + results);
                } else {
                    console.log("TUDO OK");
                    console.log("ERR: ", err);
                    console.log("RESULTS: ", results);
                    console.log("FIELDS: ", fields);
                }
            });
        }
    }

}

function convInt(campoInt) {
    return `${campoInt}`;
}
function convString(campoString) {
    return `'${campoString}'`;
}
function convData(campoData) {
    let partes = campoData.split('/');
    return `'${partes[2]}-${partes[1]}-${partes[0]}'`;
}
function convDecimal(campoDecimal) {
    return `${campoDecimal}`.replace(',', '.')
}

module.exports = acessarBD;