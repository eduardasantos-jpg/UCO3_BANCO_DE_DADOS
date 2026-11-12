/* Prática 15 – Lanchonete – juntando as tabelas
USE lanchonete;

-- pergunta 1: O número de cada pedido e o nome do cliente.
SELECT p.numero, c.nome AS cliente
FROM pedido p
INNER JOIN cliente c ON c.codigo = p.cliente_codigo;

-- pergunta 2: Os pedidos da unidade Ponta Verde (mostre o nome da unidade).
SELECT p.numero, p.data_hora, u.nome AS unidade
FROM pedido p
INNER JOIN unidade u ON u.codigo = p.unidade_codigo
WHERE u.nome = 'Ponta Verde';

-- pergunta 3: Os itens do pedido 4: data, nome do produto e quantidade.
SELECT p.data_hora, pr.nome AS produto, ip.quantidade
FROM item_pedido ip
INNER JOIN pedido p ON p.numero = ip.pedido_numero
INNER JOIN produto pr ON pr.codigo = ip.produto_codigo
WHERE p.numero = 4;

-- pergunta 4: Unidades vendidas de cada produto, com o nome, da mais vendida.
SELECT pr.nome AS produto, SUM(ip.quantidade) AS total_vendido
FROM item_pedido ip
INNER JOIN produto pr ON pr.codigo = ip.produto_codigo
GROUP BY pr.codigo, pr.nome
ORDER BY total_vendido DESC;

-- pergunta 5: Quais produtos nunca foram vendidos?
SELECT pr.codigo, pr.nome
FROM produto pr
LEFT JOIN item_pedido ip ON ip.produto_codigo = pr.codigo
WHERE ip.produto_codigo IS NULL;

-- pergunta 6: Quais clientes não fizeram nenhum pedido?
SELECT c.codigo, c.nome
FROM cliente c
LEFT JOIN pedido p ON p.cliente_codigo = c.codigo
WHERE p.cliente_codigo IS NULL;

-- pergunta 7: Quais produtos têm preço de tabela acima da média?
SELECT nome, preco_tabela
FROM produto
WHERE preco_tabela > (SELECT AVG(preco_tabela) FROM produto);

-- pergunta 8: Qual a média de pedidos por unidade?
SELECT AVG(t.qtd_pedidos) AS media_pedidos_por_unidade
FROM (
    SELECT unidade_codigo, COUNT(*) AS qtd_pedidos
    FROM pedido
    GROUP BY unidade_codigo
) AS t;

-- Extra (sem nota): o faturamento de cada unidade, com o nome da unidade (3 tabelas e SUM).
SELECT u.nome AS unidade, SUM(ip.quantidade * ip.preco_cobrado) AS faturamento
FROM unidade u
INNER JOIN pedido p ON p.unidade_codigo = u.codigo
INNER JOIN item_pedido ip ON ip.pedido_numero = p.numero
GROUP BY u.codigo, u.nome;