# 직접 서버 배포 가이드 (GitHub Pages 없이)

## 1. 서버 준비

### Jekyll 빌드
```bash
# 프로젝트 디렉토리에서
bundle exec jekyll build

# 빌드된 파일은 _site 디렉토리에 생성됩니다
```

## 2. 웹 서버 설정 (Nginx)

### Nginx 설치
```bash
sudo apt update
sudo apt install -y nginx
```

### Nginx 설정 파일 생성
`/etc/nginx/sites-available/prl.gwnu.ac.kr` 파일 생성:

```nginx
server {
    listen 80;
    server_name prl.gwnu.ac.kr;
    
    root /path/to/your/project/_site;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
}
```

### 사이트 활성화
```bash
sudo ln -s /etc/nginx/sites-available/prl.gwnu.ac.kr /etc/nginx/sites-enabled/
sudo nginx -t  # 설정 테스트
sudo systemctl restart nginx
```

## 3. SSL 인증서 설정 (Let's Encrypt)

### Certbot 설치
```bash
sudo apt install -y certbot python3-certbot-nginx
```

### SSL 인증서 발급
```bash
sudo certbot --nginx -d prl.gwnu.ac.kr
```

이 명령어가 자동으로:
- SSL 인증서 발급
- Nginx 설정에 HTTPS 추가
- 자동 갱신 설정

## 4. DNS 설정

학교 IT 담당자에게 요청:
- **도메인**: `prl.gwnu.ac.kr`
- **레코드 타입**: A 레코드 또는 CNAME
- **값**: 서버의 공인 IP 주소

### A 레코드 사용 시
```
Name: prl
Type: A
Value: [서버 공인 IP 주소]
```

### CNAME 사용 시 (서브도메인만 가능)
```
Name: prl
Type: CNAME
Value: [다른 도메인]
```

## 5. 방화벽 설정

```bash
# HTTP, HTTPS 포트 열기
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

## 6. 자동 배포 스크립트 (선택사항)

배포 스크립트 생성 `deploy.sh`:

```bash
#!/bin/bash
# Jekyll 빌드 및 Nginx 재시작

cd /path/to/your/project
bundle exec jekyll build
sudo systemctl reload nginx
echo "배포 완료!"
```

실행 권한 부여:
```bash
chmod +x deploy.sh
```

## 주의사항

1. **CNAME 파일**: 직접 서버 배포 시 CNAME 파일은 필요 없습니다 (GitHub Pages 전용)
2. **자동 갱신**: Let's Encrypt 인증서는 90일마다 자동 갱신됩니다
3. **백업**: 정기적으로 `_site` 디렉토리 백업 권장

