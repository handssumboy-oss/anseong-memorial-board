-- Supabase SQL Editor 에 그대로 붙여넣고 실행한다.

create table public.tributes (
  id         bigint generated always as identity primary key,
  author     text not null check (char_length(author) between 1 and 30),
  message    text not null check (char_length(message) between 1 and 1000),
  status     text not null default 'pending' check (status in ('pending', 'approved', 'rejected')),
  created_at timestamptz not null default now()
);

create index tributes_status_idx on public.tributes (status, id desc);

create table public.flowers (
  id         bigint generated always as identity primary key,
  created_at timestamptz not null default now()
);

alter table public.tributes enable row level security;
alter table public.flowers  enable row level security;

-- 방문자는 pending 상태로만 등록할 수 있다
create policy tributes_insert_anon on public.tributes
  for insert to anon with check (status = 'pending');

-- 방문자에게는 승인된 글만 보인다
create policy tributes_select_anon on public.tributes
  for select to anon using (status = 'approved');

-- 로그인한 관리자는 전체 조회와 상태 변경이 가능하다
create policy tributes_admin on public.tributes
  for all to authenticated using (true) with check (true);

-- 헌화는 익명 집계만 저장한다
create policy flowers_insert_anon on public.flowers
  for insert to anon with check (true);

create policy flowers_select_anon on public.flowers
  for select to anon using (true);
