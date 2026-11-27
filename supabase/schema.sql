-- Schema khởi tạo tham khảo cho Supabase PostgreSQL.
-- Cần rà soát RLS và xác thực trước khi đưa vào production.

create extension if not exists pgcrypto;

create table if not exists public.categories (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  sort_order int not null default 0,
  is_active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  category_id uuid references public.categories(id) on delete set null,
  name text not null,
  description text,
  image_url text,
  price integer not null check (price >= 0),
  is_available boolean not null default true,
  is_featured boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  full_name text not null,
  phone text not null,
  created_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  order_code text unique not null,
  customer_name text not null,
  phone text not null,
  address text not null,
  note text,
  delivery_time text,
  latitude double precision,
  longitude double precision,
  total integer not null check (total >= 0),
  status text not null default 'Mới',
  items jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

create table if not exists public.order_status_logs (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references public.orders(id) on delete cascade,
  old_status text,
  new_status text not null,
  changed_at timestamptz not null default now(),
  changed_by uuid references auth.users(id)
);

create table if not exists public.store_settings (
  id uuid primary key default gen_random_uuid(),
  store_name text not null default 'Bếp Của Phương',
  address text not null default '17 Nguyễn Du, xã Chư Prông, tỉnh Gia Lai',
  opening_time time not null default '07:00',
  closing_time time not null default '21:00',
  phone text,
  accepts_orders boolean not null default true,
  updated_at timestamptz not null default now()
);

-- Không bật public write/read policy mặc định.
-- Tạo policy dựa trên auth.uid() và role quản trị sau khi thiết lập tài khoản.
alter table public.categories enable row level security;
alter table public.products enable row level security;
alter table public.customers enable row level security;
alter table public.orders enable row level security;
alter table public.order_status_logs enable row level security;
alter table public.store_settings enable row level security;

-- Ví dụ: cho phép đọc danh mục/món đang hoạt động từ website công khai.
create policy "Public can read active categories" on public.categories
for select using (is_active = true);
create policy "Public can read available products" on public.products
for select using (is_available = true);

-- Chưa tạo policy INSERT đơn hàng công khai vì cần triển khai RPC/Edge Function
-- để xác thực dữ liệu, tính lại tổng tiền và chống spam trước khi mở public.
