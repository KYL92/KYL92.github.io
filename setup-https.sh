#!/bin/bash
# HTTPS(443) 설정 스크립트

echo "========================================="
echo "HTTPS(443) 설정 스크립트"
echo "========================================="
echo ""

DOMAIN="prl.gwnu.ac.kr"
NGINX_CONFIG="/etc/nginx/sites-available/${DOMAIN}"

# 1. 방화벽에서 포트 443 열기
echo "[1/4] 방화벽에서 포트 443 열기..."
sudo ufw allow 443/tcp
echo "포트 443이 열렸습니다."

# 2. Nginx 설정 백업
echo ""
echo "[2/4] 기존 Nginx 설정 백업..."
if [ -f "$NGINX_CONFIG" ]; then
    sudo cp "$NGINX_CONFIG" "${NGINX_CONFIG}.backup.$(date +%Y%m%d_%H%M%S)"
    echo "백업 완료: ${NGINX_CONFIG}.backup.*"
else
    echo "경고: 기존 설정 파일을 찾을 수 없습니다."
fi

# 3. SSL 인증서 발급 (Let's Encrypt)
echo ""
echo "[3/4] Let's Encrypt SSL 인증서 발급..."
echo ""
echo "⚠️ 중요: SSL 인증서 발급을 위해서는 포트 포워딩이 먼저 설정되어 있어야 합니다!"
echo "   Let's Encrypt는 외부에서 포트 80으로 접속하여 인증을 수행합니다."
echo "   포트 포워딩이 설정되지 않은 경우 인증서 발급이 실패합니다."
echo ""
echo "포트 포워딩 설정 확인 중..."
echo "외부에서 접속 테스트: curl -I http://prl.gwnu.ac.kr"
echo ""

# certbot이 설치되어 있는지 확인
if ! command -v certbot &> /dev/null; then
    echo "certbot이 설치되어 있지 않습니다. 설치 중..."
    sudo apt update
    sudo apt install -y certbot python3-certbot-nginx
fi

# SSL 인증서 발급 시도
echo "SSL 인증서를 발급받습니다..."
sudo certbot --nginx -d "$DOMAIN" --non-interactive --agree-tos --email admin@${DOMAIN} --redirect

if [ $? -eq 0 ]; then
    echo "✅ SSL 인증서 발급 성공!"
else
    echo "❌ SSL 인증서 발급 실패"
    echo ""
    echo "실패 원인 가능성:"
    echo "1. 포트 포워딩이 설정되지 않아 외부에서 접속 불가"
    echo "2. 도메인이 외부에서 접속 가능하지 않음"
    echo "3. 포트 80이 차단되어 있음"
    echo ""
    echo "수동으로 인증서를 발급받으려면:"
    echo "  sudo certbot --nginx -d ${DOMAIN}"
    exit 1
fi

# 4. Nginx 설정 테스트 및 재시작
echo ""
echo "[4/4] Nginx 설정 테스트 및 재시작..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "✅ Nginx 설정이 올바릅니다."
    sudo systemctl reload nginx
    echo "✅ Nginx가 재시작되었습니다."
else
    echo "❌ Nginx 설정에 오류가 있습니다. 설정을 확인하세요."
    exit 1
fi

echo ""
echo "========================================="
echo "HTTPS 설정 완료!"
echo "========================================="
echo ""
echo "다음 URL로 접속해보세요:"
echo "  - https://${DOMAIN}"
echo "  - https://${DOMAIN} (자동으로 HTTP에서 HTTPS로 리다이렉트됨)"
echo ""
echo "테스트 명령어:"
echo "  curl -I https://${DOMAIN}"
echo ""

