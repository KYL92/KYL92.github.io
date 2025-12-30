#!/bin/bash
# Jekyll 빌드 및 Nginx 재시작

cd /home/prlab/Desktop/KYL92.github.io

# Jekyll 캐시 권한 문제 해결 (캐시 삭제 후 재생성)
if [ -d ".jekyll-cache" ]; then
    rm -rf .jekyll-cache 2>/dev/null
fi

# Jekyll 빌드
bundle exec jekyll build

# Nginx 설정 테스트 후 재시작
if sudo nginx -t > /dev/null 2>&1; then
    sudo systemctl reload nginx
    echo "✅ 배포 완료! 사이트가 업데이트되었습니다."
else
    echo "❌ Nginx 설정 오류! 배포가 완료되었지만 nginx 재시작 실패"
    echo "다음 명령어로 오류 확인: sudo nginx -t"
    exit 1
fi

