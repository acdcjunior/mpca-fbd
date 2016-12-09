-- Diarias por Favorecido

SELECT d.documento, d.dt_diaria, d.valor, f.nome, f.cpf
FROM diaria d
INNER JOIN favorecido f ON d.favorecido = f.cpf
WHERE f.nome LIKE '%<<PARAMETRO>>%' or f.cpf LIKE '%<<PARAMETRO>>%'

------------------------------------------------------------------------
-- Diarias por Orgao (UG/Orgao/Org.Sup)
SELECT *
FROM diaria d
INNER JOIN unidade_gestora ug ON d.ug_pagadora = ug.codigo
INNER JOIN orgao org ON ug.orgao = org.codigo
INNER JOIN orgao orgsup ON org.orgao_sup = orgsup.codigo
WHERE
g.nome LIKE '%<<PARAMETRO>>%'
or org.nome LIKE '%<<PARAMETRO>>%'
or orgsup.nome LIKE '%<<PARAMETRO>>%'

------------------------------------------------------------------------
-- Valor por programa
SELECT p.nome, sum(d.valor)
FROM diaria d
INNER JOIN acao a ON d.acao = a.codigo
INNER JOIN programa p ON a.programa = p.codigo
GROUP BY p.nome
HAVING sum(d.valor) >= <<PARAMETRO>>

------------------------------------------------------------------------
-- Valor por funcao
SELECT f.nome, sum(d.valor)
FROM diaria d
INNER JOIN acao a ON d.acao = a.codigo
INNER JOIN subfuncao sf ON sf.codigo = a.subfuncao
INNER JOIN funcao f ON f.codigo = sf.funcao
GROUP BY f.nome
HAVING sum(d.valor) >= <<PARAMETRO>>
