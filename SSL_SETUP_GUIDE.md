# SSL 인증서 발급 가이드 (HTTPS 설정)

## ⚠️ 중요: 순서를 반드시 지켜주세요!

SSL 인증서 발급을 위해서는 **먼저 포트 포워딩이 설정되어 있어야 합니다.**

## 왜 포트 포워딩이 먼저 필요한가?

Let's Encrypt는 **HTTP-01 챌린지** 방식을 사용합니다:
1. Let's Encrypt 서버가 `http://prl.gwnu.ac.kr/.well-known/acme-challenge/...` 경로로 접속 시도
2. **외부에서 포트 80으로 접속 가능해야 함** (포트 포워딩 필수)
3. 인증 파일이 올바르게 제공되면 인증서 발급

**포트 포워딩이 없으면 외부 접속이 불가능하므로 인증서 발급 실패!**

## 단계별 가이드

### 1단계: 포트 포워딩 설정 (필수)

학교 IT 담당자에게 `IT_REQUEST.md` 파일을 전달하고 다음 포트 포워딩을 요청:

```
외부 IP: 220.66.241.119
포트 80 (HTTP) → 내부: 10.50.118.59:80
포트 443 (HTTPS) → 내부: 10.50.118.59:443
```

### 2단계: 포트 포워딩 확인

외부 네트워크(모바일 데이터 등)에서 테스트:

```bash
curl -I http://prl.gwnu.ac.kr
# 결과: HTTP/1.1 200 OK 가 나와야 함
```

**200 OK가 나오면 포트 포워딩이 정상 작동하는 것입니다!**

### 3단계: SSL 인증서 발급

포트 포워딩이 확인되면 SSL 인증서를 발급받습니다:

```bash
# 자동화 스크립트 사용 (권장)
./setup-https.sh

# 또는 수동 실행
sudo certbot --nginx -d prl.gwnu.ac.kr
```

### 4단계: HTTPS 확인

SSL 인증서 발급 후 확인:

```bash
# HTTPS 접속 테스트
curl -I https://prl.gwnu.ac.kr
# 결과: HTTP/2 200 (HTTPS 연결 성공)

# HTTP에서 HTTPS로 자동 리다이렉트 확인
curl -I http://prl.gwnu.ac.kr
# 결과: HTTP/1.1 301 Moved Permanently (HTTPS로 리다이렉트)
```

## 문제 해결

### 인증서 발급 실패 시

**오류 메시지**: "Failed to connect", "Connection timeout" 등

**원인**: 포트 포워딩이 설정되지 않았거나 작동하지 않음

**해결**:
1. IT 담당자에게 포트 포워딩 설정 확인 요청
2. 외부에서 `curl -I http://prl.gwnu.ac.kr` 테스트
3. 200 OK가 나올 때까지 1단계로 돌아가기

### 인증서 발급 성공 후에도 HTTPS 접속 안 될 때

1. Nginx 설정 확인: `sudo nginx -t`
2. Nginx 재시작: `sudo systemctl reload nginx`
3. 방화벽에서 포트 443 열기: `sudo ufw allow 443/tcp`

## 요약

```
포트 포워딩 설정 (IT 담당자 요청)
    ↓
외부 접속 확인 (curl -I http://prl.gwnu.ac.kr → 200 OK)
    ↓
SSL 인증서 발급 (certbot 또는 setup-https.sh)
    ↓
HTTPS 접속 확인 (curl -I https://prl.gwnu.ac.kr → HTTP/2 200)
```

## 관련 파일

- `IT_REQUEST.md` - IT 담당자에게 전달할 요청 사항
- `setup-https.sh` - SSL 인증서 발급 자동화 스크립트
- `EXTERNAL_ACCESS_FIX.md` - 외부 접속 문제 해결 가이드

