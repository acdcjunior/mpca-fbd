<?php

function getResults($stmt) {
    // http://stackoverflow.com/a/12632827/1850609
    // http://stackoverflow.com/a/6241477/1850609

    // initialise some empty arrays
    $fields = $results = array();

    // Get metadata for field names
    $meta = $stmt->result_metadata();

    // This is the tricky bit dynamically creating an array of variables to use to bind the results
    while ($field = $meta->fetch_field()) {
        $var = $field->name;
        $$var = null;
        $fields[$var] = &$$var;
    }

    // Bind Results
    call_user_func_array(array($stmt,'bind_result'),$fields);

    // Fetch Results
    $i = 0;
    while ($stmt->fetch()) {
        $results[$i] = array();
        foreach($fields as $k => $v)
            $results[$i][$k] = $v;
        $i++;
    }
    return $results;
}

function setParams($stmt, $params) {
    if (sizeof($params) < 1) {
        return;
    }
    $types = '';
    foreach($params as $param) {
        if(is_int($param)) {
            $types .= 'i';              //integer
        } elseif (is_float($param)) {
            $types .= 'd';              //double
        } elseif (is_string($param)) {
            $types .= 's';              //string
        } else {
            $types .= 'b';              //blob and unknown
        }
    }
    array_unshift($params, $types);

    call_user_func_array(array($stmt,'bind_param'), refValues($params));
}

function refValues($arr){
    http://stackoverflow.com/a/16120923/1850609
    if (strnatcmp(phpversion(),'5.3') >= 0) //Reference is required for PHP 5.3+
    {
        $refs = array();
        foreach($arr as $key => $value)
            $refs[$key] = &$arr[$key];
        return $refs;
    }
    return $arr;
}

class DiariasRepository {

    function DiariasRepository()
    {
        $this->mysqli = new mysqli("mysql.hostinger.com.br","u990873117_user","maristela",'u990873117_base');
        if (mysqli_connect_errno()) {
            printf("Connect failed: %s\n", mysqli_connect_error());
            exit();
        }
    }

    function close()
    {
        $this->mysqli->close();
    }

    function sql($sql, $params)
    {
        if ($stmt = $this->mysqli->prepare($sql)) {
            setParams($stmt, $params);
            $stmt->execute();
            $results = getResults($stmt);
            $stmt->close();
            return $results;
        } else {
            printf("PAU NA CONSULTA!");
            exit();
        }
    }

    function diariasPorFavorecido($parametro)
    {
        return $this->sql(
            "SELECT d.documento, d.dt_diaria, d.valor, f.nome, f.cpf
             FROM diaria d INNER JOIN favorecido f ON d.favorecido = f.cpf
             WHERE f.nome LIKE CONCAT('%',?,'%') or f.cpf LIKE CONCAT('%',?,'%')
             LIMIT 10000",
            array($parametro, $parametro)
        );
    }

    function diariasPorOrgao($parametro)
    {
        return $this->sql(
            "SELECT nm_unidade_gestora, nm_orgao_subordinado, nm_orgao_superior, sum(d.valor) as valor
             FROM (select 
	osup.codigo cd_orgao_superior, osup.nome nm_orgao_superior,
    osub.codigo cd_orgao_subordinado, osub.nome nm_orgao_subordinado,
    ug.codigo cd_unidade_gestora, ug.nome nm_unidade_gestora,
    fun.codigo cd_funcao, fun.nome nm_funcao,
    sf.codigo cd_subfuncao, sf.nome nm_subfuncao,
    p.codigo cd_programa, p.nome nm_programa,
    a.codigo cd_acao, a.nome nm_acao, a.linguagem_cidada linguagem_cidada,
    f.cpf cpf_favorecido, f.nome nm_favorecido,
	d.documento, d.gestao, d.dt_diaria, d.valor
from diaria d 
	join favorecido f on d.favorecido = f.cpf
    join unidade_gestora ug on d.ug_pagadora = ug.codigo
    join orgao osub on ug.orgao = osub.codigo
    join orgao osup on osub.orgao_sup = osup.codigo
    join acao a on d.acao = a.codigo
    join programa p on a.programa = p.codigo
    join subfuncao sf on a.subfuncao = sf.codigo
    join funcao fun on sf.funcao = fun.codigo
    ) d
             WHERE
             nm_unidade_gestora LIKE CONCAT('%',?,'%')
             or nm_orgao_subordinado LIKE CONCAT('%',?,'%')
             or nm_orgao_superior LIKE CONCAT('%',?,'%')
             GROUP BY  nm_unidade_gestora, nm_orgao_subordinado, nm_orgao_superior",
            array($parametro, $parametro, $parametro)
        );
    }

    function valorPorPrograma($parametro)
    {
        return $this->sql(
            "SELECT p.nome, sum(d.valor) as valor
             FROM diaria d
             INNER JOIN acao a ON d.acao = a.codigo
             INNER JOIN programa p ON a.programa = p.codigo
             GROUP BY p.nome
             HAVING sum(d.valor) >= ?",
            array($parametro)
        );
    }

}



/*
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

}
*/