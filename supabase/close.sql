-- 온라인 추모관 글 등록 종료 (2026-09-30 운영 마감)
-- Supabase 대시보드 > SQL Editor 에 붙여넣고 Run.

-- 방문자의 글 등록을 막는다.
-- 조회 정책(tributes_select_anon)은 그대로 두어 기존 글은 계속 보인다.
-- 관리자 정책(tributes_admin)도 그대로 두어 필요 시 수정할 수 있다.
drop policy if exists tributes_insert_anon on public.tributes;

-- 확인 — tributes 에 INSERT 정책이 남아 있지 않아야 한다
select tablename, policyname, cmd, roles
from pg_policies
where schemaname = 'public' and tablename = 'tributes'
order by policyname;

-- 헌화도 함께 닫는다. 페이지에서 헌화하기 버튼을 내린 뒤에 실행한다.
-- 조회 정책(flowers_select_anon)은 그대로 두어 누적 수는 계속 표시된다.
drop policy if exists flowers_insert_anon on public.flowers;

-- 확인 — flowers 에 INSERT 정책이 남아 있지 않아야 한다
select tablename, policyname, cmd, roles
from pg_policies
where schemaname = 'public' and tablename = 'flowers'
order by policyname;
