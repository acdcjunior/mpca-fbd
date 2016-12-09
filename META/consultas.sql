-- Diarias por Favorecido

SELECT p.nome, sum(d.valor)
FROM diaria d
INNER JOIN join favorecido f ON d.favorecido = f.cpf
WHERE f.nome LIKE '%${PARAMETRO}%' or f.cpf LIKE '%${PARAMETRO}%'

-- Valor por programa

SELECT p.nome, sum(d.valor)
FROM diaria d
INNER JOIN join acao a ON d.acao = a.codigo
INNER JOIN join programa p ON a.programa = p.codigo
GROUP BY p.nome
HAVING sum(d.valor) >= ${PARAMETRO}

-- Valor por funcao

SELECT f.nome, sum(d.valor)
FROM diaria d
INNER JOIN join acao a ON d.acao = a.codigo
INNER JOIN join subfuncao sf ON sf.codigo = a.subfuncao
INNER JOIN join funcao f ON f.codigo = sf.funcao
GROUP BY f.nome
HAVING sum(d.valor) >= ${PARAMETRO}

-- Valor por funcao

SELECT sf.nome, sum(d.valor)
FROM diaria d
INNER JOIN join acao a ON d.acao = a.codigo
INNER JOIN join subfuncao sf ON sf.codigo = a.subfuncao
GROUP BY sf.nome
HAVING sum(d.valor) >= ${PARAMETRO}