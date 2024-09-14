create database db_diego_spa;
 go

 use db_diego_spa;

CREATE TABLE customer_activities (
    id INT IDENTITY(1,1) PRIMARY KEY,  -- ID autoincrementable
    client_name NVARCHAR(255),         -- Nombre del cliente
    sex CHAR(1),                       -- Sexo del cliente (por ejemplo, M/F)
    income DECIMAL(10, 2),             -- Ingresos del cliente con 2 decimales
    average_visits DECIMAL(5, 2),      -- Promedio de visitas con 2 decimales
    age INT,                           -- Edad del cliente
    use_sauna BIT,                     -- Indicador de uso de sauna (0 = No, 1 = Sí)
    use_hidro BIT,                     -- Indicador de uso de hidroterapia (0 = No, 1 = Sí)
    use_yoga BIT,                      -- Indicador de uso de yoga (0 = No, 1 = Sí)
    use_massage BIT,                   -- Indicador de uso de masaje (0 = No, 1 = Sí)
	branch_name NVARCHAR(255),         -- Nombre de la sucursal
);