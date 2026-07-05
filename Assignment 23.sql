DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS ecomm CASCADE;

CREATE TABLE ecomm (
    ProductID integer,
    ProductName varchar(100),
    Category varchar(100),
    Price numeric,
    QuantitySold integer,
    Promotion varchar(10),
    Discount numeric,
    Rating integer,
    CustomerAge integer,
    CustomerGender varchar(20),
    CustomerLocation varchar(100),
    PurchaseDate date
);

select * from ecomm;

select
	productname,
	productid,
	concat(substring(productname, 1, 3), '-', right(productid::varchar, 2)) as product_code,
	upper(customerlocation) as customer_location_clean,
	replace(category, '&', 'and') as category_clean
from
	ecomm;

select
	date_trunc('month', purchasedate) as bulan_tren,
	extract(year from purchasedate) as tahun_validasi,
	extract(month from purchasedate) as bulan_validasi,
	count(*) as total_transaksi,
	sum(price*quantitysold*(1-(discount/100.0))) as total_net_revenue
from
	ecomm
group by
	date_trunc('month', purchasedate),
	extract(year from purchasedate),
	extract(month from purchasedate)
order by
	bulan_tren asc;

select
	productid,
	productname,
	purchasedate,
	now() as waktu_sistem_now,
	current_timestamp as waktu_sistem_timestamp
from 
	ecomm
where
	purchasedate >= (select max(purchasedate) from ecomm) - interval '7day'
order by
	purchasedate desc;

select
	productid,
	productname,
	price
from 
	ecomm
where
	price > (select avg(price) from ecomm)
order by
	price asc;

with hitung_revenue as (
	select
		productid,
		productname,
		price,
		quantitysold,
		discount,
		(price * quantitysold * (1 - (discount / 100.0))) as net_revenue
	from
		ecomm
)

select
	productid,
	productname,
	net_revenue
from
	hitung_revenue
where
	net_revenue > (select avg(net_revenue) from hitung_revenue)
order by
	net_revenue asc;

select
	productname,
	sum(quantitysold) as total_terjual
from
	ecomm
group by 
	productname
order by 
	total_terjual desc 
limit 10;

with tabel_ranking as (
	select
		category,
		productname,
		sum(quantitysold) as total_terjual,
		dense_rank() over (
			partition by category
			order by sum(quantitysold) desc 
		) as peringkat_kategori
	from 
		ecomm
group by 
		category,
		productname
)
select 
	category,
	productname,
	total_terjual,
	peringkat_kategori
from 
	tabel_ranking 
where 
	peringkat_kategori <=3
order by 
	category asc,
	peringkat_kategori asc;