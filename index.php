<?php
require 'vendor/autoload.php';
require "DiariasRepository.php";

$app = new Slim\App();
$diariasRepo = new DiariasRepository();

/* CORS - INICIO */
$app->options('/{routes:.+}', function ($request, $response, $args) {
    return $response;
});

$app->add(function ($req, $res, $next) {
    $response = $next($req, $res);
    return $response
        ->withHeader('Access-Control-Allow-Origin', 'http://acdcjunior.github.io')
        ->withHeader('Access-Control-Allow-Headers', 'X-Requested-With, Content-Type, Accept, Origin, Authorization')
        ->withHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
});
/* CORS - FIM */


$app->get('/diarias-por-favorecido', function ($request, $response) {
    global $diariasRepo;
    return $response->withStatus(200)->withJson($diariasRepo->diariasPorFavorecido($request->getQueryParam('busca', '')));
});

$app->run();