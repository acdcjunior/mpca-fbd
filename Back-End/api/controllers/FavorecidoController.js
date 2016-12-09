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
    INNER JOIN favorecido f ON d.favorecido = f.cpf
    WHERE f.nome LIKE '%<<PARAMETRO>>%' or f.cpf LIKE '%<<PARAMETRO>>%'
    LIMIT 10000
    `
  ),
  diariasPorOrgao: consultar(
    'Diarias por Orgao',
    `
    SELECT nm_unidade_gestora, nm_orgao_subordinado, nm_orgao_superior, sum(d.valor) as valor
    FROM vw_diarias d
    WHERE
    nm_unidade_gestora LIKE '%<<PARAMETRO>>%'
    or nm_orgao_subordinado LIKE '%<<PARAMETRO>>%'
    or nm_orgao_superior LIKE '%<<PARAMETRO>>%'
    GROUP BY  nm_unidade_gestora, nm_orgao_subordinado, nm_orgao_superior
    `
  ),
  valorPorPrograma: consultar(
    'Valor por Programa',
    `
    SELECT p.nome, sum(d.valor) as valor
    FROM diaria d
    INNER JOIN acao a ON d.acao = a.codigo
    INNER JOIN programa p ON a.programa = p.codigo
    GROUP BY p.nome
    HAVING sum(d.valor) >= <<PARAMETRO>>
    `
  ),
  valorPorFuncao: consultar(
    'Valor por Funcao',
    `
    SELECT f.nome, sum(d.valor) as valor
    FROM diaria d
    INNER JOIN acao a ON d.acao = a.codigo
    INNER JOIN subfuncao sf ON sf.codigo = a.subfuncao
    INNER JOIN funcao f ON f.codigo = sf.funcao
    GROUP BY f.nome
    HAVING sum(d.valor) >= <<PARAMETRO>>
    `
  ),
  valorPorDia: consultar(
    'Valor por Dia',
    `
    SELECT dt_diaria, sum(valor) as valor
    FROM diaria d
    GROUP BY dt_diaria
    ORDER BY dt_diaria
    `
  )

};
