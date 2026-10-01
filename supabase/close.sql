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

-- 헌화(flowers)는 건드리지 않는다. 버튼이 페이지에 남아 있으므로
-- 함께 닫으려면 페이지에서 버튼을 먼저 내려야 한다.
