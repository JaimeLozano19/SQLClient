
drop database LOZANOJAIME;
-- creamos la base de datos--
create database if not exists LOZANOJAIME character set = "utf8" collate = "utf8_unicode_ci";

-- indicamos que vamos a usar la base de datos--
USE LOZANOJAIME;

-- primer punto--
-- creamos la tabla cliente--
create table if not exists CLIENTE(
	Cod_cliente int auto_increment,
	Nombre_cliente varchar(20) not null,
    Mail_cliente varchar(70) not null,
    Tel_cliente varchar(20) not null,
    constraint cons_PK_Cliente primary key (Cod_cliente)
);
-- creamos la tabla producto--
create table if not exists PRODUCTO(
	Cod_producto int auto_increment,
	Nombre_producto varchar(20) not null,
    stock_producto int not null,
    Precio_producto double not null,
    constraint cons_PK_Cliente primary key (Cod_producto)
);

-- creamos la tabla venta--
create table if not exists Venta(
	Cod_cliente int not null ,
	Cod_producto int not null ,
    fecha_venta datetime not null,
    cant_venta int not null,
    tot_venta double not null,
 
	foreign key (Cod_cliente) references cliente (Cod_cliente),
    foreign key (Cod_producto) references producto (Cod_producto)
);
-- ingresamos datos--
-- ingresar datos en la tabla cliente--
insert into cliente (nombre_cliente, mail_cliente,tel_cliente)
values('Jaime lozano','jolozanog@ut.edu.co','3113182473');
insert into cliente (nombre_cliente, mail_cliente,tel_cliente)
values('andres matta','andres@gmail.com','3103182473');
insert into cliente (nombre_cliente, mail_cliente,tel_cliente)
values('luis meneses','luis@hotmail.com','3123182473');
insert into cliente (nombre_cliente, mail_cliente,tel_cliente)
values('pedro rojas','prdro@gmail.com','3133182473');
insert into cliente (nombre_cliente, mail_cliente,tel_cliente)
values('carlos rojas','carlos@yahoo.com','3143182473');
insert into cliente (nombre_cliente, mail_cliente,tel_cliente)
values('peter rojas','peter@yahoo.com','3153182473');

-- ingresamos datos en al tabla producto --
insert into producto (nombre_producto, stock_producto,precio_producto)
values('Samsung s10','10','3000000');
insert into producto (nombre_producto, stock_producto,precio_producto)
values('Samsung s9','7','2000000');
insert into producto (nombre_producto, stock_producto,precio_producto)
values('Samsung s20','13','5000000');
insert into producto (nombre_producto, stock_producto,precio_producto)
values('iphone 13','5','6000000');
insert into producto (nombre_producto, stock_producto,precio_producto)
values('iphone 12','8','4000000');
insert into producto (nombre_producto, stock_producto,precio_producto)
values('huawei y7','8','400000');

-- ingresamos valores en la tabla venta --
insert into venta (cod_cliente, cod_producto, fecha_venta, cant_venta, tot_venta)
values('1','1',NOW(),'5','15000000');
insert into venta (cod_cliente, cod_producto, fecha_venta, cant_venta, tot_venta)
values('2','2',NOW(),'3','6000000');
insert into venta (cod_cliente, cod_producto, fecha_venta, cant_venta, tot_venta)
values('3','3',NOW(),'2','10000000');
insert into venta (cod_cliente, cod_producto, fecha_venta, cant_venta, tot_venta)
values('4','4',NOW(),'1','6000000');
insert into venta (cod_cliente, cod_producto, fecha_venta, cant_venta, tot_venta)
values('5','5',NOW(),'1','4000000');
insert into venta (cod_cliente, cod_producto, fecha_venta, cant_venta, tot_venta)
values('6','6',NOW(),'1','400000');



-- punto 2--
-- creamos un trigger para la tabla producto--
create table if not exists Aud_producto(
	Cod_producto int ,
	Nombre_producto varchar(20) not null,
    stock_producto varchar(20) not null,
    Precio_producto double not null,
    evento varchar(15),
    fecha_evento datetime
);
-- creamos el trigger--
create trigger Tr_Update_Producto before update on producto
FOR each row
insert into aud_producto
values (old.cod_producto, old.Nombre_producto , old.stock_producto,old.precio_producto,'actualización' ,NOW());


-- punto 3--
-- creamos la tabla VentaBackup --
create table if not exists VentaBackup(
	Cod_cliente int not null,
	Cod_producto int not null,
    fecha_venta datetime not null,
    cant_venta int not null,
    tot_venta double not null
);
-- creamos el procedimiento almacenado--
DELIMITER $$
CREATE PROCEDURE Realizar_Copia_Venta ()
    BEGIN 
    TRUNCATE  TABLE VentaBackup;
    INSERT INTO VentaBackup SELECT * FROM venta v where v.tot_venta>1000000;
END$$

select * from ventaBackup;
call realizar_copia_venta;

-- punto 4--
select c.nombre_cliente, p.nombre_producto,(tot_venta) 'Venta mayor a 2.000.000'
from venta v, cliente c, producto p
where c.cod_cliente=v.cod_cliente and v.cod_producto= p.cod_producto and v.tot_venta>2000000 and v.fecha_venta BETWEEN '2022-02-01' AND '2022-03-01' ;

-- punto 5--
SELECT v.*,c.nombre_cliente, c.Mail_cliente
FROM venta v, cliente c, producto p
WHERE c.cod_cliente=v.cod_cliente and v.cod_producto= p.cod_producto and c.Mail_cliente like "%yahoo.com";

-- punto 6--

SELECT  c.Mail_cliente, c.tel_cliente, p.precio_producto,
CASE
          WHEN p.precio_producto > 1500000
          THEN 'Aplican impuestos'
          WHEN p.precio_producto < 1500000
          THEN 'No aplica impuesto' 
	  END AS 'Relacion_Impuesto'
FROM venta v, cliente c, producto p
WHERE c.cod_cliente=v.cod_cliente and v.cod_producto= p.cod_producto;

-- punto 7--
SELECT p.nombre_producto, p.cod_producto, c.cod_cliente, c.nombre_cliente, c.mail_cliente, p.stock_producto
FROM venta v, cliente c, producto p
WHERE c.cod_cliente=v.cod_cliente and v.cod_producto= p.cod_producto and p.stock_producto <10;