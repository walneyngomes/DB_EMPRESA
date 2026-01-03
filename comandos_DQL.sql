-- Retorna apenas o primeiro registro (TOP 1),
-- ou seja, o cliente que teve o MAIOR valor total de compras
SELECT TOP (1)
       c.NomeCompleto,          -- Nome completo do cliente
       SUM(dp.Preco) AS TotalGasto -- Soma do preço dos itens comprados
FROM TB_CLIENTE c

-- Relaciona o cliente com seus pedidos
INNER JOIN TB_PEDIDO p
    ON c.ClienteId = p.ClienteId

-- Relaciona o pedido com os detalhes (itens do pedido)
INNER JOIN TB_DETALHE_PEDIDO dp
    ON dp.NumeroPedido = p.NumeroPedido

-- Filtra pedidos realizados entre 01/07/1996 e 31/07/1996
WHERE p.DataPedido BETWEEN '1996-07-01' AND '1996-07-31'

-- Agrupa por cliente para poder somar os valores
GROUP BY c.NomeCompleto

-- Ordena do maior total gasto para o menor
ORDER BY SUM(dp.Preco) DESC;


--------------------------------------------------------------
  -- Seleciona todas as colunas do cliente e do endereço
SELECT *
FROM TB_CLIENTE c

-- Relaciona cliente com endereço
INNER JOIN TB_ENDERECO e
    ON c.ClienteId = e.ClienteId

-- Filtra apenas endereços localizados na Alemanha
WHERE e.Pais = 'Alemanha';
------------------------------------------------------------

  -- Retorna o nome dos clientes
SELECT c.NomeCompleto
FROM TB_CLIENTE c

-- Relaciona cliente com pedidos
INNER JOIN TB_PEDIDO p
    ON p.ClienteId = c.ClienteId

-- Relaciona pedidos com seus itens
INNER JOIN TB_DETALHE_PEDIDO pd
    ON pd.NumeroPedido = p.NumeroPedido

-- Relaciona itens com produtos
INNER JOIN TB_PRODUTO prod
    ON prod.ProdutoId = pd.ProdutoId

-- Relaciona produtos com categorias
INNER JOIN TB_CATEGORIA cat
    ON cat.CategoriaId = prod.CategoriaId

-- Filtra apenas produtos da categoria Bebidas
WHERE cat.Descricao = 'Bebidas';
-------------------------------------------------
  --🔹 4. Análise de vendas com meta batida ou não (Agosto/1996)


  SELECT TB1.*,CASE WHEN TB1.TOTAL_UNITARIO >= 5000 THEN 'BATEU A META' 
			ELSE 'NAO BATEU A META'
			END AS [STATUS]

FROM (
SELECT UPPER(C.NomeCompleto) AS [NOME_COMPLETO], UPPER(C.Contato) AS  [CONTATO], sum(DP.Quantidade) AS [QUANTIDADE], CONCAT(DATEPART(YEAR,PED.DataEntrega),'-',DATEPART(MONTH,PED.DataEntrega)) AS [ANO_MES], SUM(DP.Preco) AS [PRECO], SUM(DP.Quantidade)*SUM(DP.Preco) AS [TOTAL_UNITARIO]
FROM  TB_CLIENTE C
INNER JOIN TB_PEDIDO PED 
ON PED.ClienteId = C.ClienteId
INNER JOIN TB_DETALHE_PEDIDO DP
ON DP.NumeroPedido = PED.NumeroPedido
WHERE DATEPART(MONTH,PED.DataEntrega) = 8 AND DATEPART(YEAR,PED.DataEntrega) = 1996
group by  C.NomeCompleto ,  C.Contato ,CONCAT(DATEPART(YEAR,PED.DataEntrega),'-',DATEPART(MONTH,PED.DataEntrega))
 ) AS TB1


select c.Descricao,DATEPART(YEAR,PED.DataPedido),sum(tpd.Quantidade*tpd.Preco) as total from TB_CATEGORIA AS C
INNER JOIN TB_PRODUTO P
ON p.CategoriaId = C.CategoriaId
INNER JOIN TB_DETALHE_PEDIDO as tpd
ON tpd.ProdutoId = p.ProdutoId
INNER JOIN TB_PEDIDO PED
ON PED.NumeroPedido = tpd.NumeroPedido
where DATEPART(YEAR,PED.DataPedido) = 1996 
group by c.Descricao, DATEPART(YEAR,PED.DataPedido)

