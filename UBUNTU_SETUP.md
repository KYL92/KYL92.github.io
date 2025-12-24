# Ubuntu 24.04에서 Jekyll 사이트 실행 가이드

이 문서는 Ubuntu 24.04 환경에서 이 Jekyll 사이트를 실행하는 방법을 설명합니다.

## 사전 요구사항

### 1. 시스템 패키지 업데이트 및 필수 도구 설치

```bash
sudo apt update
sudo apt upgrade -y
sudo apt install -y build-essential git curl
```

### 2. Ruby 설치

Ubuntu 24.04에서는 여러 방법으로 Ruby를 설치할 수 있습니다:

#### 방법 1: rbenv 사용 (권장)

```bash
# rbenv 설치에 필요한 패키지
sudo apt install -y libssl-dev libreadline-dev zlib1g-dev

# rbenv 설치
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# 환경 변수 설정 (셸 설정 파일에 추가)
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init - bash)"' >> ~/.bashrc

# 설정 적용
source ~/.bashrc

# Ruby 3.2.0 설치 (3.3.0에서 listen gem 문제가 있으므로 3.2.0 권장)
rbenv install 3.2.0
rbenv global 3.2.0

# Ruby 버전 확인
ruby -v
```

#### 방법 2: Ubuntu 기본 패키지 사용

```bash
sudo apt install -y ruby-full ruby-dev
ruby -v
```

### 3. Bundler 설치

```bash
gem install bundler
```

### 4. 프로젝트 클론 및 의존성 설치

```bash
# 프로젝트 디렉토리로 이동
cd /path/to/project

# Bundler로 의존성 설치
bundle install
```

만약 `bundle install` 중 오류가 발생하면, 다음 추가 패키지를 설치하세요:

```bash
sudo apt install -y libffi-dev libyaml-dev
```

## 서버 실행

### 일반 모드 (파일 변경 자동 감지)

```bash
bundle exec jekyll serve
```

### 포트 및 호스트 지정

```bash
bundle exec jekyll serve --host 0.0.0.0 --port 4000
```

### 파일 변경 감지 없이 실행 (--no-watch)

만약 `listen` gem 관련 문제가 발생하면:

```bash
bundle exec jekyll serve --no-watch
```

## Ubuntu 24.04 특이사항

1. **Ruby 버전**: Ubuntu 24.04의 기본 Ruby 버전을 사용하거나, rbenv로 Ruby 3.2.x 버전을 설치하는 것을 권장합니다. Ruby 3.3.0에서 일부 gem 호환성 문제가 있을 수 있습니다.

2. **파일 시스템 감시**: Ubuntu에서는 `listen` gem이 `inotify`를 사용합니다. 대부분의 경우 문제없이 작동합니다.

3. **방화벽**: 서버를 외부에서 접근하려면 포트를 열어야 합니다:
   ```bash
   sudo ufw allow 4000/tcp
   ```

## 문제 해결

### 문제: "cannot load such file -- listen/silencer/controller"

**해결 방법 1**: Ruby 버전을 3.2.x로 다운그레이드
```bash
rbenv install 3.2.0
rbenv local 3.2.0
bundle install
```

**해결 방법 2**: `--no-watch` 옵션 사용
```bash
bundle exec jekyll serve --no-watch
```

### 문제: "Failed to build native extension"

필수 개발 도구가 설치되지 않았을 수 있습니다:
```bash
sudo apt install -y build-essential ruby-dev libffi-dev libyaml-dev zlib1g-dev libssl-dev
bundle install
```

### 문제: 권한 오류

`sudo`를 사용하지 않고 gem을 설치하도록 합니다. `~/.gem` 디렉토리 권한 확인:
```bash
chmod -R u+w ~/.gem
```

## 프로덕션 배포

### Nginx와 함께 사용

프로덕션 환경에서는 빌드된 사이트를 Nginx로 서빙하는 것을 권장합니다:

```bash
# Jekyll 사이트 빌드
bundle exec jekyll build

# 빌드된 사이트는 _site 디렉토리에 생성됩니다
# Nginx 설정에서 이 디렉토리를 루트로 지정하세요
```

### systemd 서비스로 등록

`/etc/systemd/system/jekyll.service` 파일 생성:

```ini
[Unit]
Description=Jekyll Site Server
After=network.target

[Service]
Type=simple
User=your-username
WorkingDirectory=/path/to/project
ExecStart=/home/your-username/.rbenv/shims/bundle exec jekyll serve --host 0.0.0.0 --port 4000
Restart=always

[Install]
WantedBy=multi-user.target
```

서비스 활성화:
```bash
sudo systemctl daemon-reload
sudo systemctl enable jekyll
sudo systemctl start jekyll
```

## 참고 링크

- [Jekyll 공식 문서](https://jekyllrb.com/docs/)
- [Jekyll Ubuntu 설치 가이드](https://jekyllrb.com/docs/installation/ubuntu/)
- [rbenv 설치 가이드](https://github.com/rbenv/rbenv#installation)

