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

}



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

}
*/