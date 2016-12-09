/* global Favorecido */
"use strict";

function consultar(nomeDaConsulta, sql) {
  return function(req, res) {
    let parametroFornecido = (req.query.busca || '').replace(/['"]/g, ''); // tratamento de SQL injection minimo!

    const sqlEfetivo = sql.replace(/<<PARAMETRO>>/g, parametroFornecido);
    Favorecido.query(sqlEfetivo,
      function (err, results) {
        if (err) {
          console.error(`Erro na busca: ${nomeDaConsulta}!`);
          console.error(`SQL EFETIVO: ${sqlEfetivo}`);
          console.error(err);
          res.send(400);
        }
        else {
          res.send(results);
        }
      });
  };
}

module.exports = {

  diariasPorFavorecido: consultar(
    'Diarias por favorecido',
    `
    SELECT d.documento, d.dt_diaria, d.valor, f.nome, f.cpf
    FROM diaria d
    INNER JOIN join favorecido f ON d.favorecido = f.cpf
    WHERE f.nome LIKE '%<<PARAMETRO>>%' or f.cpf LIKE '%<<PARAMETRO>>%'
    `
  ),
  diariasPorOrgao: consultar(
    'Diarias por Orgao',
    `
    SELECT *
    FROM diaria d
    INNER JOIN join unidade_gestora ug ON d.ug_pagadora = ug.codigo
    INNER JOIN join orgao org ON ug.orgao = org.codigo
    INNER JOIN join orgao orgsup ON org.orgao_sup = orgsup.codigo
    WHERE
    g.nome LIKE '%<<PARAMETRO>>%'
    or org.nome LIKE '%<<PARAMETRO>>%'
    or orgsup.nome LIKE '%<<PARAMETRO>>%'
    `
  ),
  valorPorPrograma: consultar(
    'Valor por Programa',
    `
    SELECT p.nome, sum(d.valor)
    FROM diaria d
    INNER JOIN join acao a ON d.acao = a.codigo
    INNER JOIN join programa p ON a.programa = p.codigo
    GROUP BY p.nome
    HAVING sum(d.valor) >= <<PARAMETRO>>
    `
  ),
  valorPorFuncao: consultar(
    'Valor por Funcao',
    `
    SELECT f.nome, sum(d.valor)
    FROM diaria d
    INNER JOIN join acao a ON d.acao = a.codigo
    INNER JOIN join subfuncao sf ON sf.codigo = a.subfuncao
    INNER JOIN join funcao f ON f.codigo = sf.funcao
    GROUP BY f.nome
    HAVING sum(d.valor) >= <<PARAMETRO>>
    `
  )

};
