# Dockerfiles

개발 환경을 위한 Docker 이미지 빌드 시스템입니다.

## 사용법

### 1. 루트 패스워드 설정

**Mac 사용자의 경우** `mkpasswd` 명령어가 없으므로 Linux 서버에서 패스워드를 생성해야 합니다:

```bash
# Linux 서버에서 실행
sudo apt install -y whois
mkpasswd
```

생성된 해시된 패스워드를 `.password` 파일에 저장합니다:

```bash
# 예시: $y$j9T$Q2DaFvKTFx3gSSgKDZrEV0$wQsDX65sDWg03ZMdla/02Vc8uIQjOhqkDcDAmtzx1G1
echo "생성된_패스워드_해시" > .password
```

### 2. 사용자 이름 설정 (선택사항)

기본적으로 현재 사용자 이름이 사용되며, 필요시 변경할 수 있습니다:

```bash
export USER_NAME=your_user_name
```

### 3. 환경 파일 생성

```bash
./init_env.sh
```

이 스크립트는 자동으로 다음 설정들을 가져옵니다:
- **SSH 공개 키**: `~/.ssh/*.pub` 파일들을 모아서 `authorized_keys`로 설정
- **Git 설정**: `~/.gitconfig` 파일이 있으면 컨테이너에 복사

### 4. Dockerfile 생성

```bash
./generate.sh
```

### 5. Docker 이미지 빌드 및 푸시

```bash
# 이미지 태그 설정
IMAGE_TAG="some-docker.pkg.dev/some-path/khl-debian-full:latest"

# 이미지 빌드
docker buildx build --platform linux/amd64 \
  -t $IMAGE_TAG \
  -f debian-full/Dockerfile .

# 이미지 푸시
docker push $IMAGE_TAG
```

### 6. Kubernetes Pod 배포

Pod 매니페스트 파일에서 이미지를 지정합니다:

```yaml
# cluster.yaml
apiVersion: v1
kind: Pod
spec:
  containers:
    - name: container-name
      image: some-docker.pkg.dev/some-path/khl-debian-full:latest
      # ... 기타 설정
```

Pod을 배포합니다:

```bash
kubectl apply -f cluster.yaml
```

### 7. SSH 서비스 시작 및 접속

```bash
# SSH 서비스 시작 (보통 안해도 됩니다)
kubectl exec pod/khl-cluster -n some-group -- service ssh start

# 포트 포워딩을 통한 SSH 접속
kubectl port-forward pod/khl-cluster 2222:22 -n some-group

# 다른 터미널에서 SSH 접속
ssh username@localhost -p 2222
```

