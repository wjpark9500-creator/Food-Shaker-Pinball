# 오늘 뭐 먹지? 🎯 실시간 핀볼

가족이 각자 폰/PC로 접속해서, 실시간으로 진행되고 결과를 절대 바꿀 수 없는
핀볼 게임으로 저녁 메뉴를 정하는 웹앱입니다. 전부 무료 서비스로 구성됩니다.

- **Supabase** (무료 플랜) : 후보 메뉴 / 게임 상태 / 최종 결과 저장 + 실시간 동기화
- **정적 사이트 1페이지** (index.html) : 네온 핀볼 보드 애니메이션
- **Vercel** (무료 플랜) : 배포 + 링크 공유
- **GitHub** (무료) : 코드 저장소

---

## 1. Supabase 프로젝트 만들기 (5분)

1. https://supabase.com 접속 → 무료로 회원가입/로그인
2. "New project" 클릭 → 프로젝트 이름 아무거나 (예: `menu-pinball`), 비밀번호 설정, 리전은 `Northeast Asia (Seoul)` 추천
3. 프로젝트가 만들어질 때까지 1~2분 대기

## 2. 테이블 및 보안 규칙 생성

1. 왼쪽 메뉴에서 **SQL Editor** 클릭 → "New query"
2. 이 폴더의 `supabase-schema.sql` 내용을 전부 복사해서 붙여넣고 **Run** 실행
3. 왼쪽 메뉴 **Database > Replication**으로 이동해서 `public.games` 테이블 옆 토글이
   켜져 있는지 확인 (SQL의 `alter publication`으로 이미 켜졌을 수도 있음)

## 3. API 키 확인

1. 왼쪽 메뉴 **Project Settings > API**
2. **Project URL** 과 **anon public** 키를 복사

## 4. 코드에 키 입력

`index.html` 파일 상단 `<script>` 부분에서 아래 두 줄을 찾아 값을 채워주세요:

```js
const SUPABASE_URL = "여기에_SUPABASE_URL_입력";
const SUPABASE_ANON_KEY = "여기에_SUPABASE_ANON_KEY_입력";
```

> anon(익명) 키는 브라우저에 노출되는 게 정상인 키입니다. 절대 넣으면 안 되는 건
> **service_role** 키뿐이니 그건 사용하지 않습니다.

## 5. GitHub에 올리기

이 폴더(`menu-pinball`)에 파일 4개(`index.html`, `vercel.json`, `supabase-schema.sql`, `README.md`)가
전부 같은 위치에 있습니다. 하위 폴더 없이 평평한 구조라 그대로 올리면 됩니다.

```bash
cd menu-pinball
git init
git add .
git commit -m "메뉴 결정 핀볼 앱"
git branch -M main
git remote add origin <새로_만든_GitHub_저장소_URL>
git push -u origin main
```

## 6. Vercel 배포

1. https://vercel.com 접속 → GitHub 계정으로 로그인
2. "Add New... > Project" → 방금 만든 저장소 Import
3. Framework Preset: **Other** (또는 감지 안 되면 그대로 두기)
4. Build Command / Output Directory는 비워두거나 기본값 그대로 → **Deploy**
5. 배포되면 나오는 URL(예: `https://menu-pinball.vercel.app`)이 최종 주소입니다

## 7. 사용하기

1. 배포된 URL로 접속 → **닉네임 입력** (닉네임 없이는 아무것도 볼 수 없음, 브라우저에 저장되어 다음에는 자동 통과)
2. **로비**에서 "➕ 새 핀볼 방 만들기" → 메뉴 후보 입력 → 방 생성
3. 로비의 **방 목록**에서 실시간으로 방이 뜨고, 가족들도 같은 URL로 들어와 닉네임만 입력하면 방 목록에서 "입장" 클릭
4. 방에 들어가면 핀볼 게임 화면, 아무나 "🚀 발사!" 버튼 클릭
5. 모든 기기에서 동시에 결과가 뜨고, 이후 절대 수정되지 않습니다
   ("공정성 검증" 눌러서 누가 만들고 누가 발사했는지, 계산 방식까지 확인 가능)

> 닉네임은 로그인이 아니라 그냥 표시용 문자열이라, 같은 닉네임을 여러 명이 써도 시스템적으로
> 막지는 않습니다. 가족끼리 쓰는 용도라 크게 문제되진 않을 거예요.

---

## 알아두면 좋은 점

- 결과가 확정(`status = done`)되면 **데이터베이스 규칙(RLS) 때문에** 이 앱을
  만든 사람도 결과를 고칠 수 없습니다. "투명하고 조작 불가능"이 코드 신뢰가
  아니라 DB 권한 자체로 보장되는 구조입니다.
- 후보 메뉴는 게임 생성 후 수정 기능을 넣지 않았습니다(원할 경우 "+ 새 게임 만들기"로
  처음부터 다시 만드는 방식). 이것도 조작 방지를 위한 설계입니다.
- Vercel은 정적 파일을 오래 캐시하는 경향이 있어 `vercel.json`에 캐시 방지 헤더를
  넣어뒀습니다. 그래도 배포 후 화면이 안 바뀌면 브라우저 강력 새로고침(Ctrl/Cmd+Shift+R)
  해보세요.
