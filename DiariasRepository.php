<?php

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
        $sql = <<<EOT
    SELECT d.documento, d.dt_diaria, d.valor, f.nome, f.cpf
    FROM diaria d
    INNER JOIN favorecido f ON d.favorecido = f.cpf
    WHERE f.nome LIKE '%joao%' or f.cpf LIKE '%joao%'
    LIMIT 10000
EOT;
        if ($stmt = $this->mysqli->prepare($sql)) {
//            $stmt->bind_param("ss", $parametro, $parametro);
            $stmt->execute();

            $arr = array();
            $stmt->bind_result($id);
            while ( $stmt->fetch() ) {
                $arr[] = $id;
            }
            $stmt->close();
            return $arr;
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