# 온라인 추모관

2026년 9월 19일 경기 안성 '나눔의 녹색장터' 사고 희생자를 위한 온라인 추모관.

GitHub Pages(정적 페이지) + Supabase(데이터)로 동작합니다. 서버를 직접 켜둘 필요가 없습니다.

---

## 1. 구조

```
memorial/
├── index.html          추모관 페이지
├── admin.html          승인 관리 (Supabase 로그인)
├── config.js           Supabase 접속 정보
├── .nojekyll           GitHub Pages 빌드 우회
└── supabase/
    └── schema.sql      테이블 + RLS 정책
```

```
방문자 → GitHub Pages (index.html) → Supabase
                                        │
담당자 → GitHub Pages (admin.html) ─────┘
```

---

## 2. Supabase 설정

1. [supabase.com](https://supabase.com) 가입 후 새 프로젝트 생성 (Region은 **Northeast Asia (Seoul)** 권장)
2. 좌측 **SQL Editor** → `supabase/schema.sql` 내용을 붙여넣고 실행
3. 좌측 **Settings → API** 에서 두 값을 복사
   - `Project URL`
   - `anon` `public` key
4. `config.js` 에 붙여넣기

```js
export const SUPABASE_URL = "https://abcdefgh.supabase.co";
export const SUPABASE_ANON_KEY = "eyJhbGciOi...";
```

### 관리자 계정 만들기

**Authentication → Users → Add user** 에서 담당자 이메일과 비밀번호를 등록합니다. 이 계정으로 `admin.html` 에 로그인합니다.

일반 방문자가 가입하지 못하도록 **Authentication → Providers → Email** 에서 `Enable sign ups` 를 **꺼둡니다.**

### anon key 는 공개되어도 됩니다

`config.js` 는 저장소에 그대로 커밋합니다. anon key 는 브라우저에 노출되도록 설계된 값이고, 실제 접근 권한은 RLS 정책이 결정합니다.

**`service_role` key 는 절대 커밋하지 마세요.** 이 키는 RLS를 무시합니다.

---

## 3. GitHub Pages 배포

1. GitHub에서 **공개(Public)** 저장소 생성 (무료 플랜은 공개 저장소만 Pages 지원)
2. 위 파일들을 업로드
3. **Settings → Pages** → Source를 `Deploy from a branch`, 브랜치 `main` / 폴더 `/ (root)` 로 지정
4. 1~2분 뒤 주소 발급

```
https://계정명.github.io/memorial/
```

승인 관리 화면은 `https://계정명.github.io/memorial/admin.html` 입니다.

---

## 4. 권한 구조

| 대상 | 추모글 등록 | 추모글 조회 | 상태 변경 | 헌화 |
|---|---|---|---|---|
| 방문자 (anon) | `pending` 으로만 | 승인된 글만 | 불가 | 가능 |
| 관리자 (로그인) | 가능 | 전체 | 가능 | 가능 |

RLS 정책으로 데이터베이스에서 강제됩니다. 브라우저에서 요청을 조작해도 승인되지 않은 글은 조회되지 않습니다.

---

## 5. 알아두실 제약

### 도배 차단이 없습니다

서버가 없으므로 IP 기준 요청 제한을 걸 수 없습니다. 현재는 브라우저 기록으로 헌화 중복만 막고 있어, 마음먹으면 우회할 수 있습니다.

실제 공개 시에는 둘 중 하나를 권합니다.

- **Cloudflare Turnstile + Supabase Edge Function** — 정석이지만 추가 구현 필요
- **Supabase Dashboard 모니터링** — 이상 급증 시 수동 대응. 추모글은 어차피 사전 승인이므로 헌화 수만 감시하면 됨

초기에는 후자로 시작하고, 문제가 생기면 전자로 전환하는 방식이 현실적입니다.

### 개인 계정 주소입니다

`계정명.github.io` 는 기관 명의가 아닙니다. 기관 도메인(`v1365.or.kr`) 담당자에게 하위 주소 연결을 요청하면 `memorial.v1365.or.kr` 로 바꿀 수 있습니다. GitHub Pages는 커스텀 도메인을 무료로 지원합니다.

---

## 6. 공개 전 채울 항목

`index.html` 안에서 `○○` 로 표시된 부분입니다.

| 위치 | 내용 |
|---|---|
| `기억하는 분들` | 유가족 서면 동의를 받은 경우에만 성함 기재 |
| `회복을 기다리며` | 부상자 지원 담당 팀명 |
| `조문 안내` | 빈소, 발인, 담당팀 연락처 |
| `footer` | 페이지 명의 |

검색 노출은 기본 차단입니다. 공개 범위가 확정되면 아래를 제거합니다.

```html
<meta name="robots" content="noindex, nofollow">
```

---

## 7. 게시 원칙

### 페이지에 쓰지 않는 것

- 사고의 경위, 원인, 책임에 관한 서술 (국과수 감정 및 수사 진행 중)
- 유가족 동의를 받지 않은 성함, 사진, 나이, 학교
- 미성년 고인의 학교·학년·사진
- 사과 또는 책임 인정으로 해석될 수 있는 표현 (사전 법무 검토 필요)

### 추모의 글 승인 기준

| 구분 | 처리 |
|---|---|
| 애도, 위로, 회복 기원 | 게시 |
| 고인·유가족 신원 추정 시도 | 보류 |
| 사고 원인 단정 | 보류 |
| 운전자·현장 관계자·주최 측 지목 및 비난 | 보류 |
| 정치적 주장, 유사 사건 언급 | 보류 |
| 외부 링크, 연락처 포함 | 보류 |
| 욕설, 반복 게시 | 보류 |

보류는 삭제가 아니라 `rejected` 상태로 남습니다. 이의 제기 시 원문 확인이 가능합니다.

---

## 8. 백업과 종료

Supabase Dashboard의 **Table Editor → tributes → Export as CSV** 로 내려받을 수 있습니다.

운영 종료 시 추모의 글을 아카이브할지, 유가족에게 전달할지, 삭제할지 사전에 정해두는 것을 권합니다.
