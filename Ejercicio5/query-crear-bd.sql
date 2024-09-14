create database db_fiorella;
 go

 use db_fiorella;

CREATE TABLE customer_activities (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- ID autoincrementable
    client_name NVARCHAR(255),         -- Nombre del cliente
    has_roses BIT,					   -- Indicador de compra de rosa (0 = No, 1 = Sí)
	has_carnations BIT,				   -- Indicador de compra de claveles (0 = No, 1 = Sí)
	has_soil BIT,                      -- Indicador de compra de tierra (0 = No, 1 = Sí)
	has_sunflowers BIT,                -- Indicador de compra de girasoles (0 = No, 1 = Sí)
	has_hydrangea BIT,                 -- Indicador de compra de hortensia (0 = No, 1 = Sí)
	has_balloons BIT,                  -- Indicador de compra de globos (0 = No, 1 = Sí)
	has_orchids BIT,                   -- Indicador de compra de Orquideas (0 = No, 1 = Sí)
	has_crimson BIT,                   -- Indicador de compra de Carmesi (0 = No, 1 = Sí)
	has_lilies BIT,                    -- Indicador de compra de Lirios (0 = No, 1 = Sí)
	has_aurora BIT,                    -- Indicador de compra de Aurora (0 = No, 1 = Sí)
	has_tulips BIT,                    -- Indicador de compra de Tulipanes (0 = No, 1 = Sí)
	has_ribbon BIT,                    -- Indicador de compra de listones (0 = No, 1 = Sí)
	has_pots BIT,                      -- Indicador de compra de Macetas (0 = No, 1 = Sí)
	branch_name NVARCHAR(50),         -- Nombre de la sucursal
);