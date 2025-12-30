# 서버 상태 현황

## ✅ 현재 상태

### 내부 접속: 성공!
- **도메인**: prl.gwnu.ac.kr
- **내부 IP**: 10.50.118.59
- **상태**: ✅ 정상 작동 중

### 외부 접속: 대기 중
- **공인 IP**: 220.66.241.119
- **상태**: ⏳ 포트 포워딩 설정 대기 중

## 서버 정보

- **Nginx**: 정상 실행 중
- **포트**: 80 (HTTP)
- **웹사이트 경로**: /home/prlab/Desktop/KYL92.github.io/_site

## 다음 단계

### 1단계: 포트 포워딩 설정 (필수)

**⚠️ 중요**: SSL 인증서 발급을 위해서는 먼저 포트 포워딩이 필요합니다!

학교 IT 담당자에게 포트 포워딩 요청 (`IT_REQUEST.md` 파일 참고):
- 포트 80 (HTTP) 포워딩: 외부 220.66.241.119:80 → 내부 10.50.118.59:80
- 포트 443 (HTTPS) 포워딩: 외부 220.66.241.119:443 → 내부 10.50.118.59:443

### 2단계: 외부 접속 확인

포트 포워딩 완료 후 외부에서 테스트:
```bash
curl -I http://prl.gwnu.ac.kr
# 200 OK가 나오면 성공!
```

### 3단계: HTTPS 설정 (선택사항)

외부 접속이 확인되면 SSL 인증서 발급:
```bash
./setup-https.sh
```

자세한 내용은 `SSL_SETUP_GUIDE.md` 참고

## 테스트 방법

### 내부 접속 테스트
```bash
curl -I http://prl.gwnu.ac.kr
# 또는 브라우저에서 http://prl.gwnu.ac.kr 접속
```

### 외부 접속 테스트 (포트 포워딩 설정 후)
```bash
# 외부 네트워크에서 (모바일 데이터 등)
curl -I http://prl.gwnu.ac.kr
curl -I https://prl.gwnu.ac.kr  # HTTPS 설정 후
```

## 관련 파일

- `IT_REQUEST.md` - IT 담당자 요청 사항
- `EXTERNAL_ACCESS_FIX.md` - 외부 접속 문제 해결 가이드
- `setup-https.sh` - HTTPS 설정 스크립트
- `deploy.sh` - 사이트 배포 스크립트

