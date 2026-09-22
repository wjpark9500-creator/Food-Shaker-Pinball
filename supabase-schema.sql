-- ============================================================
-- 오늘 뭐 먹지? 실시간 핀볼 - Supabase 스키마
-- Supabase 대시보드 > SQL Editor 에 붙여넣고 "Run" 실행
-- ============================================================

create extension if not exists pgcrypto;

create table if not exists public.games (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz not null default now(),
  options      jsonb not null,
  status       text not null default 'collecting'
               check (status in ('collecting','launched','done')),
  seed         double precision,
  launched_at  timestamptz,
  result_index int,
  result_text  text,
  result_at    timestamptz,
  created_by   text,
  launched_by  text
);

-- 이미 games 테이블을 만든 적이 있다면 (컬럼만 추가) 아래 두 줄도 실행하세요.
alter table public.games add column if not exists created_by text;
alter table public.games add column if not exists launched_by text;

alter table public.games enable row level security;

-- 누구나 읽기 가능 (가족들이 로그인 없이 결과를 봐야 하므로)
create policy "anyone can read games"
  on public.games for select
  using (true);

-- 누구나 새 게임 생성 가능
create policy "anyone can create a game"
  on public.games for insert
  with check (true);

-- ★ 핵심: status가 'done'이 된 순간, 그 누구도(앱 개발자 포함) 더 이상 수정 불가.
--   이게 "결과는 절대 바뀌지 않는다"를 DB 레벨에서 보장하는 부분입니다.
create policy "can update only while not finalized"
  on public.games for update
  using (status <> 'done')
  with check (true);

-- 실시간(Realtime) 구독 활성화
alter publication supabase_realtime add table public.games;

-- ============================================================
-- 위 ALTER PUBLICATION이 에러가 나거나 실시간이 동작하지 않으면:
-- Supabase 대시보드 > Database > Replication 으로 이동해서
-- "public" 스키마의 games 테이블 옆 토글을 수동으로 ON 하세요.
-- ============================================================
