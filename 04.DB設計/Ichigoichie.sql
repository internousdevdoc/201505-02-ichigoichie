create database if not exists Ichigoichie;

use Ichigoichie;

set foreign_key_checks=0;

drop table if exists customer_info;
create table customer_info (
customer_id int(10) not null primary key auto_increment,
customer_name varchar(100) not null,
customer_pass varchar(32) not null,
email_address varchar(100) not null,
tel_number varchar(11) not null,
customer_address varchar(100) not null,
address_number varchar(30) not null,
customer_postcode int(7) not null,
customer_age tinyint not null,
unique_id varchar(20)
);

drop table if exists merchandise_info;
create table merchandise_info (
item_id tinyint not null primary key auto_increment,
item_name varchar(50) not null,
price int(10) not null
);

drop table if exists shop_info;
create table shop_info(
shop_id tinyint not null primary key,
shop_name varchar(30) not null,
shop_address varchar(100) not null,
shop_postcode int(7) not null
);

drop table if exists inventory_info;
create table inventory_info(
shop_id tinyint not null,
foreign key(shop_id) references shop_info(shop_id),
item_id tinyint not null,
foreign key(item_id) references merchandise_info(item_id),
item_count tinyint not null,
rental_date date not null
);

drop table if exists order_info;
create table order_info (
customer_id int(10) not null,
foreign key(customer_id) references customer_info(customer_id),
shop_id tinyint not null,
foreign key(shop_id) references shop_info(shop_id),
item_id tinyint not null,
foreign key(item_id) references merchandise_info(item_id),
unit_price int(10) not null,
payment_method tinyint not null,
credit_company tinyint not null,
credit_number bigint(16) not null,
security_code int(4) not null,
expiration_date int(4) not null,
rental_date date not null
);

drop table if exists calendar;
create table calendar(
day date not null,
shop_id tinyint,
foreign key(shop_id) references shop_info(shop_id),
item_id tinyint,
foreign key(item_id) references merchandise_info(item_id)
);

drop table if exists purchase_history;
create table purchase_history(
customer_id int(10) not null,
foreign key(customer_id) references customer_info(customer_id),
rental_date date not null,
sales_count int(3) not null,
unit_price int(10) not null
);

drop table if exists mail_magazine;
create table mail_magazine(
title varchar(100),
contents text
);

drop table if exists administrator;
create table administrator(
admin_id varchar(25) not null,
admin_pass varchar(25) not null
);

set foreign_key_checks=1;

insert into merchandise_info values
(1, '浴衣', 5000),
(2, '振袖', 19000),
(3, '甚平', 4000),
(4, '単衣', 6000),
(5, '袴', 10000),
(6, '七五三用着物', 16000);

insert into shop_info values
(1, '一期一会御茶ノ水店', '東京都文京区湯島3-2-12　御茶ノ水天神ビル2F', 1130034),
(2, '一期一会浅草店', '東京都台東区浅草1-41-4', 1110032),
(3, '一期一会お台場店', '東京都港区台場1-7-1 アクアシティお台場6F', 1350091),
(4, '一期一会原宿店', '東京都渋谷区 神宮前6-1-9', 1500001);

insert into administrator values ('internousdev02', 'internous01');

insert into customer_info values (1, 'やまーだ', 'fjfjfjfj', 'yamada@co.jp', 09000000000, '山田のおうち', 1234, 1234567, 24, null);