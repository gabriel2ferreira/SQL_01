-- Criação das tabelas
CREATE TABLE Cliente (
    ClienteID INT PRIMARY KEY,
    Nome VARCHAR(255),
    Email VARCHAR(255),
    Tipo VARCHAR(2)
);

CREATE TABLE Produto (
    ProdutoID INT PRIMARY KEY,
    Nome VARCHAR(255),
    Descricao TEXT,
    Preco DECIMAL(10, 2)
);
CREATE TABLE Pagamento (
    PagamentoID INT PRIMARY KEY,
    PedidoID INT,
    FormaPagamento VARCHAR(50),
    ValorPago DECIMAL(10, 2),
    FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID)
);

CREATE TABLE Entrega (
    EntregaID INT PRIMARY KEY,
    PedidoID INT,
    StatusEntrega VARCHAR(50),
    CodigoRastreio VARCHAR(100) UNIQUE,
    FOREIGN KEY (PedidoID) REFERENCES Pedido(PedidoID)
);

CREATE TABLE Fornecedor (
    FornecedorID INT PRIMARY KEY,
    Nome VARCHAR(255)
);

CREATE TABLE Estoque (
    EstoqueID INT PRIMARY KEY,
    ProdutoID INT,
    FornecedorID INT,
    QuantidadeEmEstoque INT,
    FOREIGN KEY (ProdutoID) REFERENCES Produto(ProdutoID),
    FOREIGN KEY (FornecedorID) REFERENCES Fornecedor(FornecedorID)
);


-- Definição de chaves estrangeiras
ALTER TABLE Pedido
ADD CONSTRAINT FK_Pedido_Cliente
FOREIGN KEY (ClienteID)
REFERENCES Cliente(ClienteID);

ALTER TABLE ItemPedido
ADD CONSTRAINT FK_ItemPedido_Pedido
FOREIGN KEY (PedidoID)
REFERENCES Pedido(PedidoID);


-- Restrições adicionais e índices.
ALTER TABLE Pagamento
ADD CONSTRAINT CK_ValorPago CHECK (ValorPago >= 0);
CREATE INDEX IX_Produto_Nome ON Produto(Nome);

-- Exemplo de consulta 
ALTER TABLE Entrega
ADD CONSTRAINT UQ_CodigoRastreio
UNIQUE (CodigoRastreio);

--Pedidos 
SELECT Cliente.Nome, COUNT(Pedido.PedidoID) AS QuantidadePedidos
FROM Cliente
LEFT JOIN Pedido ON Cliente.ClienteID = Pedido.ClienteID
GROUP BY Cliente.Nome;

-- Vendedor e Fornecedor
SELECT Cliente.Nome, COUNT(Pedido.PedidoID) AS QuantidadePedidos
FROM Cliente
LEFT JOIN Pedido ON Cliente.ClienteID = Pedido.ClienteID
GROUP BY Cliente.Nome;

--Relação de produtos, fornecedores e estoque
SELECT Produto.Nome, Fornecedor.Nome AS NomeFornecedor, Estoque.QuantidadeEmEstoque
FROM Produto
INNER JOIN Estoque ON Produto.ProdutoID = Estoque.ProdutoID
INNER JOIN Fornecedor ON Estoque.FornecedorID = Fornecedor.FornecedorID;

--Relação de nomes dos fornecedores e nomes dos produtos
SELECT Fornecedor.Nome AS NomeFornecedor, GROUP_CONCAT(Produto.Nome ORDER BY Produto.Nome ASC) AS ProdutosFornecidos
FROM Fornecedor
INNER JOIN Estoque ON Fornecedor.FornecedorID = Estoque.FornecedorID
INNER JOIN Produto ON Estoque.ProdutoID = Produto.ProdutoID
GROUP BY Fornecedor.Nome;
