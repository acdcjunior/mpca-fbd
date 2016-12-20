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

    function diariasPorFavorecido($parametro)
    {
        $sql = "SELECT d.documento, d.dt_diaria, d.valor, f.nome, f.cpf FROM diaria d INNER JOIN favorecido f ON d.favorecido = f.cpf WHERE f.nome LIKE CONCAT('%',?,'%') or f.cpf LIKE CONCAT('%',?,'%') LIMIT 10000";
        $params = array($parametro, $parametro);

        if ($stmt = $this->mysqli->prepare($sql)) {

            call_user_func_array(array($stmt,'bind_param'),$params);

            $stmt->execute();

            $results = getResults($stmt);
//            $arr = array();
//            $stmt->bind_result($documento, $dt_diaria, $valor, $nome, $cpf);
//            while ( $stmt->fetch() ) {
//                $obj = new stdClass;
//                $obj->documento = $documento;
//                $obj->dt_diaria = $dt_diaria;
//                $obj->valor = $valor;
//                $obj->nome = $nome;
//                $obj->cpf = $cpf;
//                $arr[] = $obj;
//            }
            $stmt->close();
            return $results;
        } else {
            printf("PAU NA CONSULTA!");
            exit();
        }
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