<?php
require 'vendor/autoload.php';
require "DiariasRepository.php";

$app = new Slim\App();
$diariasRepo = new DiariasRepository();

/* CORS - INICIO */
$corsOptions = array(
    "origin" => "*",
    "exposeHeaders" => array("Content-Type", "X-Requested-With", "X-authentication", "X-client"),
    "allowMethods" => array('GET', 'POST', 'PUT', 'DELETE', 'OPTIONS')
);
$cors = new \CorsSlim\CorsSlim($corsOptions);
/* CORS - FIM */

$app->get('/diarias-por-favorecido', function ($request, $response) {
    global $diariasRepo;
    return $response->withStatus(200)->withJson($diariasRepo->diariasPorFavorecido($request->getQueryParam('busca', '')));
});
$app->get('/diarias-por-orgao', function ($request, $response) {
    global $diariasRepo;
    return $response->withStatus(200)->withJson($diariasRepo->diariasPorOrgao($request->getQueryParam('busca', '')));
});
$app->get('/valor-por-programa', function ($request, $response) {
    global $diariasRepo;
    return $response->withStatus(200)->withJson($diariasRepo->valorPorPrograma($request->getQueryParam('busca', '')));
});
$app->get('/valor-por-funcao', function ($request, $response) {
    global $diariasRepo;
    return $response->withStatus(200)->withJson($diariasRepo->valorPorFuncao($request->getQueryParam('busca', '')));
});
$app->get('/valor-por-dia', function ($request, $response) {
    global $diariasRepo;
    return $response->withStatus(200)->withJson($diariasRepo->valorPorDia($request->getQueryParam('busca', '')));
});

$app->run();