INSERT INTO users (email, hashed_password, full_name, role)
VALUES ('never_ordered@example.com', 'not-a-real-hash', 'No Orders Yet', 'member')
ON CONFLICT (email) DO NOTHING;

INSERT INTO products (name, category, price, stock)
SELECT 'Unreleased Prototype', 'Electronics', 999.99, 0
WHERE NOT EXISTS (
    SELECT 1 FROM products
    WHERE name = 'Unreleased Prototype'
);

select 
	orders.id,
	users.email,
	products.name,
	orders.quantity,
	orders.created_at::date
from orders
join users
	on orders.user_id = users.id
join products
	on orders.product_id = products.id;
order by orders.created_at::date asc;

select users.email
from users
left join orders 
	on users.id = orders.user_id 
where orders.user_id is null;

select 
	status,
	count(*)
from orders
group by status
order by count(*) desc;

select 
	status, 
	count(*)
from orders 
group by status
order by count(*) desc;

select 
	products.category,
	sum(products.price * orders.quantity)
from orders
join products 
on orders.product_id = products.id
group by products.category 
order by sum(products.price * orders.quantity) desc;

select 
	users.email,
	sum(orders.quantity)
from orders 
join users 
	on orders.user_id = users.id
group by users.email 
order by sum(orders.quantity) desc 
limit 5;

select 
	category,
	avg(price)
from products 
group by category 
having avg(price) > (
	select avg(price)
	from products
)
order by avg(price) desc;

select 
	users.email,
	count(*)
from orders 
join users 
	on orders.user_id = users.id 
group by users.email 
having count(*) > 40
order by count(*) desc;

select products.name
from products 
left join orders 
	on products.id = orders.product_id 
where orders.product_id is null;
