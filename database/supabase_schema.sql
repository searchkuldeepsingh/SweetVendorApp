create table if not exists public.sweets (
  id text primary key,
  name text not null,
  price numeric not null,
  image_url text not null,
  description text not null,
  rating numeric not null default 4.5,
  review_count integer not null default 0
);

create table if not exists public.orders (
  id text primary key,
  customer_name text not null,
  customer_phone text not null,
  delivery_address text not null,
  placed_by_username text not null,
  placed_by_role text not null check (placed_by_role in ('customer', 'agent')),
  total_amount numeric not null,
  placed_at timestamptz not null,
  payment_method text not null default 'cash_on_delivery',
  status text not null default 'placed' check (status in ('placed', 'confirmed'))
);

create table if not exists public.order_items (
  id bigint generated always as identity primary key,
  order_id text not null references public.orders(id) on delete cascade,
  sweet_id text not null,
  sweet_name text not null,
  sweet_price numeric not null,
  quantity integer not null check (quantity > 0)
);

alter table public.sweets enable row level security;
alter table public.orders enable row level security;
alter table public.order_items enable row level security;

drop policy if exists "Allow public sweets read" on public.sweets;
create policy "Allow public sweets read"
on public.sweets for select
using (true);

drop policy if exists "Allow public orders read" on public.orders;
create policy "Allow public orders read"
on public.orders for select
using (true);

drop policy if exists "Allow public orders insert" on public.orders;
create policy "Allow public orders insert"
on public.orders for insert
with check (true);

drop policy if exists "Allow public order items insert" on public.order_items;
create policy "Allow public order items insert"
on public.order_items for insert
with check (true);

drop policy if exists "Allow public order items read" on public.order_items;
create policy "Allow public order items read"
on public.order_items for select
using (true);

insert into public.sweets (
  id,
  name,
  price,
  image_url,
  description,
  rating,
  review_count
) values
('1', 'Gulab Jamun', 149, 'assets/images/gluabjamun.jpeg', 'Soft and juicy Indian sweet balls dipped in sugar syrup.', 4.9, 245),
('2', 'Jalebi', 129, 'assets/images/Jalebi.jpeg', 'Crispy spiral sweets soaked in saffron syrup.', 4.8, 218),
('3', 'Rasgulla', 179, 'assets/images/Rasgulla.jpeg', 'Soft cheese balls soaked in light sugar syrup.', 4.7, 174),
('4', 'Laddu', 109, 'assets/images/laddu.jpeg', 'Traditional round sweets made with ghee and flour.', 4.7, 190),
('5', 'Kaju Katli', 249, 'assets/images/Kajukatli.jpeg', 'Premium cashew fudge with silver coating.', 4.8, 206),
('6', 'Barfi', 159, 'assets/images/Berfi.jpeg', 'Classic milk-based sweet with rich flavor.', 4.6, 156),
('7', 'Motichoor Laddu', 189, 'assets/images/laddu.jpeg', 'Tiny boondi pearls shaped into rich festive laddus.', 4.7, 128),
('8', 'Besan Laddu', 169, 'assets/images/laddu.jpeg', 'Aromatic gram flour laddus roasted in ghee for bulk gifting.', 4.6, 96),
('9', 'Soan Papdi', 139, 'assets/images/Berfi.jpeg', 'Flaky cube sweets often ordered for festivals and office boxes.', 4.4, 84),
('10', 'Mysore Pak', 219, 'assets/images/Berfi.jpeg', 'Rich ghee and gram flour sweet with a melt-in-mouth texture.', 4.8, 112),
('11', 'Peda', 179, 'assets/images/Berfi.jpeg', 'Soft milk peda, a popular choice for prasad and celebrations.', 4.6, 101),
('12', 'Milk Cake', 229, 'assets/images/Berfi.jpeg', 'Grainy caramelized milk sweet packed well for large orders.', 4.7, 89),
('13', 'Dry Fruit Barfi', 299, 'assets/images/Kajukatli.jpeg', 'Premium dry fruit barfi for wedding and corporate gifting.', 4.8, 76),
('14', 'Kalakand', 239, 'assets/images/Berfi.jpeg', 'Moist milk cake sweet topped with nuts for festive trays.', 4.6, 73),
('15', 'Cham Cham', 199, 'assets/images/Rasgulla.jpeg', 'Spongy Bengali sweet commonly ordered for family functions.', 4.5, 68),
('16', 'Imarti', 149, 'assets/images/Jalebi.jpeg', 'Crisp syrup-soaked sweet, ideal for fresh bulk party orders.', 4.5, 82)
on conflict (id) do update set
  name = excluded.name,
  price = excluded.price,
  image_url = excluded.image_url,
  description = excluded.description,
  rating = excluded.rating,
  review_count = excluded.review_count;
