-- Sadat Mobile Center / Supabase database
-- این فایل را در Supabase > SQL Editor اجرا کن.
-- Email confirmations را در Authentication > Providers > Email روشن نگه دار.

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default 'کاربر موبایل',
  xp integer not null default 0 check (xp >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.lesson_progress (
  user_id uuid not null references auth.users(id) on delete cascade,
  lesson_id text not null,
  completed boolean not null default false,
  completed_at timestamptz,
  primary key (user_id, lesson_id)
);

alter table public.profiles enable row level security;
alter table public.lesson_progress enable row level security;

drop policy if exists "profiles_select_own" on public.profiles;
create policy "profiles_select_own" on public.profiles
for select using (auth.uid() = id);

drop policy if exists "profiles_update_own" on public.profiles;
create policy "profiles_update_own" on public.profiles
for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "lesson_select_own" on public.lesson_progress;
create policy "lesson_select_own" on public.lesson_progress
for select using (auth.uid() = user_id);

drop policy if exists "lesson_insert_own" on public.lesson_progress;
create policy "lesson_insert_own" on public.lesson_progress
for insert with check (auth.uid() = user_id);

drop policy if exists "lesson_update_own" on public.lesson_progress;
create policy "lesson_update_own" on public.lesson_progress
for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- ساخت پروفایل خودکار هنگام ثبت‌نام
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.profiles(id, display_name)
  values (new.id, coalesce(new.raw_user_meta_data->>'display_name','کاربر موبایل'))
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();

-- افزایش XP فقط برای کاربر واردشده
create or replace function public.add_xp(amount integer)
returns void
language plpgsql
security invoker
as $$
begin
  if amount is null or amount <= 0 or amount > 1000 then
    raise exception 'invalid XP amount';
  end if;
  update public.profiles
  set xp = xp + amount, updated_at = now()
  where id = auth.uid();
end;
$$;

grant execute on function public.add_xp(integer) to authenticated;
