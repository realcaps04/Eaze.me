-- Eaze.me — user profiles (run in Supabase SQL Editor)
--
-- Registration fields (lib/screens/auth/register_screen.dart):
--   full_name  → profiles.full_name
--   email      → auth.users.email + profiles.email
--   phone      → profiles.phone
--   password   → auth.users only (never stored in public tables)
--   terms      → profiles.terms_accepted_at (checkbox must be checked to register)
--
-- Supabase Auth already provides auth.users. This public table extends it.

-- ---------------------------------------------------------------------------
-- profiles
-- ---------------------------------------------------------------------------
create table if not exists public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  full_name text not null check (char_length(trim(full_name)) > 0),
  email text not null check (position('@' in email) > 1),
  phone text not null check (char_length(trim(phone)) > 0),
  avatar_url text,
  terms_accepted_at timestamptz not null default now(),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

comment on table public.profiles is
  'App user profile data for Eaze.me (one row per auth.users account).';

create unique index if not exists profiles_email_unique_idx
  on public.profiles (lower(email));

create index if not exists profiles_phone_idx
  on public.profiles (phone);

-- ---------------------------------------------------------------------------
-- updated_at helper
-- ---------------------------------------------------------------------------
create or replace function public.set_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists profiles_set_updated_at on public.profiles;

create trigger profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

-- ---------------------------------------------------------------------------
-- Auto-create profile when a new auth user registers
-- ---------------------------------------------------------------------------
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  accepted_at timestamptz;
begin
  accepted_at := coalesce(
    nullif(new.raw_user_meta_data->>'terms_accepted_at', '')::timestamptz,
    now()
  );

  insert into public.profiles (
    id,
    full_name,
    email,
    phone,
    terms_accepted_at
  )
  values (
    new.id,
    coalesce(nullif(trim(new.raw_user_meta_data->>'full_name'), ''), 'Unknown'),
    coalesce(new.email, ''),
    coalesce(nullif(trim(new.raw_user_meta_data->>'phone'), ''), ''),
    accepted_at
  );

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;

create trigger on_auth_user_created
after insert on auth.users
for each row
execute function public.handle_new_user();

-- Keep profile email in sync when auth email changes
create or replace function public.handle_user_email_updated()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.email is distinct from old.email then
    update public.profiles
    set email = new.email
    where id = new.id;
  end if;
  return new;
end;
$$;

drop trigger if exists on_auth_user_email_updated on auth.users;

create trigger on_auth_user_email_updated
after update of email on auth.users
for each row
execute function public.handle_user_email_updated();

-- ---------------------------------------------------------------------------
-- Row Level Security
-- ---------------------------------------------------------------------------
alter table public.profiles enable row level security;

drop policy if exists "Profiles: select own" on public.profiles;
create policy "Profiles: select own"
  on public.profiles
  for select
  to authenticated
  using (auth.uid() = id);

drop policy if exists "Profiles: update own" on public.profiles;
create policy "Profiles: update own"
  on public.profiles
  for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

-- Inserts are performed by handle_new_user() trigger (security definer).
-- No direct client insert policy is required.
