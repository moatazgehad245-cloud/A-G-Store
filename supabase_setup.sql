-- A&G Store database setup (run in Supabase SQL Editor)
create extension if not exists pgcrypto;

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null check (char_length(name) between 1 and 120),
  category text not null default 'أخرى',
  price numeric(12,2) not null check (price >= 0),
  old_price numeric(12,2) check (old_price is null or old_price >= 0),
  description text not null default '',
  badge text,
  image_url text,
  image_path text,
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.store_settings (
  id integer primary key check (id = 1),
  phone text not null default '',
  whatsapp text not null default '',
  address text not null default '',
  description text not null default '',
  facebook text not null default '',
  instagram text not null default '',
  updated_at timestamptz not null default now()
);
insert into public.store_settings (id) values (1) on conflict (id) do nothing;

alter table public.admin_users enable row level security;
alter table public.products enable row level security;
alter table public.store_settings enable row level security;

-- Admin status is checked by the server-side policy using the authenticated user ID.
create or replace function public.is_store_admin()
returns boolean language sql stable security definer
set search_path = public
as $$
  select exists (select 1 from public.admin_users where user_id = auth.uid());
$$;
revoke all on function public.is_store_admin() from public;
grant execute on function public.is_store_admin() to anon, authenticated;

drop policy if exists "admins can read admin list" on public.admin_users;
create policy "admins can read admin list" on public.admin_users
for select to authenticated using (public.is_store_admin());

drop policy if exists "public can read active products" on public.products;
create policy "public can read active products" on public.products
for select to anon, authenticated using (active = true or public.is_store_admin());

drop policy if exists "admins can insert products" on public.products;
create policy "admins can insert products" on public.products
for insert to authenticated with check (public.is_store_admin());

drop policy if exists "admins can update products" on public.products;
create policy "admins can update products" on public.products
for update to authenticated using (public.is_store_admin()) with check (public.is_store_admin());

drop policy if exists "admins can delete products" on public.products;
create policy "admins can delete products" on public.products
for delete to authenticated using (public.is_store_admin());

drop policy if exists "public can read store settings" on public.store_settings;
create policy "public can read store settings" on public.store_settings
for select to anon, authenticated using (true);

drop policy if exists "admins can insert store settings" on public.store_settings;
create policy "admins can insert store settings" on public.store_settings
for insert to authenticated with check (public.is_store_admin());

drop policy if exists "admins can update store settings" on public.store_settings;
create policy "admins can update store settings" on public.store_settings
for update to authenticated using (public.is_store_admin()) with check (public.is_store_admin());

-- Storage bucket for product photos
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('product-images', 'product-images', true, 5242880, array['image/jpeg','image/png','image/webp','image/gif'])
on conflict (id) do update set public = true, file_size_limit = 5242880,
  allowed_mime_types = array['image/jpeg','image/png','image/webp','image/gif'];

drop policy if exists "public can view product images" on storage.objects;
create policy "public can view product images" on storage.objects
for select using (bucket_id = 'product-images');

drop policy if exists "admins can upload product images" on storage.objects;
create policy "admins can upload product images" on storage.objects
for insert to authenticated with check (bucket_id = 'product-images' and public.is_store_admin());

drop policy if exists "admins can update product images" on storage.objects;
create policy "admins can update product images" on storage.objects
for update to authenticated using (bucket_id = 'product-images' and public.is_store_admin())
with check (bucket_id = 'product-images' and public.is_store_admin());

drop policy if exists "admins can delete product images" on storage.objects;
create policy "admins can delete product images" on storage.objects
for delete to authenticated using (bucket_id = 'product-images' and public.is_store_admin());
