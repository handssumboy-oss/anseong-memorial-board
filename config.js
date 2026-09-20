// Supabase 프로젝트의 Settings > API 에서 확인한 값을 넣는다.
// anon key 는 공개되도록 설계된 값이다. 실제 접근 권한은 RLS 정책이 결정한다.
// service_role key 는 절대 여기에 넣지 않는다.

export const SUPABASE_URL = "https://프로젝트ID.supabase.co";
export const SUPABASE_ANON_KEY = "여기에_anon_public_key";
