-- Diarias por Favorecido

SELECT d.documento, d.dt_diaria, d.valor, f.nome, f.cpf
FROM diaria d
INNER JOIN favorecido f ON d.favorecido = f.cpf
WHERE f.nome LIKE '%<<PARAMETRO>>%' or f.cpf LIKE '%<<PARAMETRO>>%'

------------------------------------------------------------------------
-- Diarias por Orgao (UG/Orgao/Org.Sup)
SELECT nm_unidade_gestora, nm_orgao_subordinado, nm_orgao_superior, sum(d.valor) as valor
FROM vw_diarias d
WHERE
nm_unidade_gestora LIKE '%<<PARAMETRO>>%'
or nm_orgao_subordinado LIKE '%<<PARAMETRO>>%'
or nm_orgao_superior LIKE '%<<PARAMETRO>>%'
GROUP BY  nm_unidade_gestora, nm_orgao_subordinado, nm_orgao_superior

------------------------------------------------------------------------
-- Valor por programa
SELECT p.nome, sum(d.valor) as valor
FROM diaria d
INNER JOIN acao a ON d.acao = a.codigo
INNER JOIN programa p ON a.programa = p.codigo
GROUP BY p.nome
HAVING sum(d.valor) >= <<PARAMETRO>>

------------------------------------------------------------------------
-- Valor por funcao
SELECT f.nome, sum(d.valor) as valor
FROM diaria d
INNER JOIN acao a ON d.acao = a.codigo
INNER JOIN subfuncao sf ON sf.codigo = a.subfuncao
INNER JOIN funcao f ON f.codigo = sf.funcao
GROUP BY f.nome
HAVING sum(d.valor) >= <<PARAMETRO>>
