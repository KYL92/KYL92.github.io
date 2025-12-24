#!/bin/bash
# Ubuntu 24.04 Jekyll 설치 스크립트

set -e

echo "========================================="
echo "Ubuntu 24.04 Jekyll 설치 스크립트"
echo "========================================="

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. 시스템 패키지 업데이트
echo -e "${GREEN}[1/6] 시스템 패키지 업데이트 중...${NC}"
sudo apt update
sudo apt upgrade -y

# 2. 필수 패키지 설치
echo -e "${GREEN}[2/6] 필수 패키지 설치 중...${NC}"
sudo apt install -y build-essential git curl libssl-dev libreadline-dev zlib1g-dev \
    libffi-dev libyaml-dev libreadline-dev libxml2-dev libxslt1-dev

# 3. rbenv 설치
echo -e "${GREEN}[3/6] rbenv 설치 중...${NC}"
if [ ! -d "$HOME/.rbenv" ]; then
    curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
    
    # 환경 변수 설정
    if ! grep -q 'rbenv' ~/.bashrc; then
        echo '' >> ~/.bashrc
        echo '# rbenv' >> ~/.bashrc
        echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc
    fi
    
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init - bash)"
else
    echo -e "${YELLOW}rbenv가 이미 설치되어 있습니다.${NC}"
    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init - bash)"
fi

# 4. Ruby 3.2.0 설치 (3.3.0에서 listen gem 문제가 있으므로 3.2.0 사용)
echo -e "${GREEN}[4/6] Ruby 3.2.0 설치 중 (이 작업은 시간이 걸릴 수 있습니다)...${NC}"
if ! rbenv versions | grep -q "3.2.0"; then
    rbenv install 3.2.0
fi
rbenv global 3.2.0

# Ruby 버전 확인
echo -e "${GREEN}설치된 Ruby 버전:${NC}"
ruby -v

# 5. Bundler 설치
echo -e "${GREEN}[5/6] Bundler 설치 중...${NC}"
gem install bundler

# 6. 프로젝트 의존성 설치
echo -e "${GREEN}[6/6] 프로젝트 의존성 설치 중...${NC}"
if [ -f "Gemfile" ]; then
    bundle install
else
    echo -e "${YELLOW}경고: Gemfile을 찾을 수 없습니다. 프로젝트 디렉토리에서 실행하세요.${NC}"
fi

echo ""
echo -e "${GREEN}========================================="
echo "설치 완료!"
echo "=========================================${NC}"
echo ""
echo "다음 명령어로 서버를 실행하세요:"
echo "  bundle exec jekyll serve"
echo ""
echo "또는 외부 접근을 허용하려면:"
echo "  bundle exec jekyll serve --host 0.0.0.0 --port 4000"
echo ""
echo "주의: 새로운 터미널에서는 다음을 실행하세요:"
echo "  source ~/.bashrc"
echo ""

