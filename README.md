# flutter_application_test

## 1. 라이브러리 설치

- flutter pub get 명령어를 통해 필요한 라이브러리들 설치
- iOS 테스트를 위해 cd ios > pod install 명령어 실행

## 2. dotenv 설정

.env_example을 참고하여 dotenv 설정

WEBVIEW_URL에 들어갈 값 설정하는 법

1. 본인이 사용하고 있는 와이파이의 IP 주소 확인 <br />
   참고: https://cloud101.tistory.com/31
2. 웹뷰에 띄우고 싶은 프로젝트 실행 후 http://${wifi ip}:${port} 형태로 입력
