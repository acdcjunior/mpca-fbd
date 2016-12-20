<?php
require 'vendor/autoload.php';


require "DiariasRepository.php";
$diariasRepo = new DiariasRepository();





$app = new Slim\App();


$app->get('/diarias-por-favorecido', function ($request, $response) {
    global $diariasRepo;
    return $response->withStatus(200)->withJson($diariasRepo->diariasPorFavorecido($request->getQueryParam('busca', '')));
});

$app->run();

/*
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
*/