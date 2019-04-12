# docker-compose
docker-compose test ( nginx - springboot- mysql)

1. docker-compose.yml
 1.1. mysql
   - 환경 변수를 설정하여, db에 접속정보를 세팅
   - volume 을 설정하여, data 를 외부로 빼냄
   - 기본 포트 3306 을 expose 하고 동일한 포트로 포워딩함
   - 아래 java runtime environment 에서 link 를 했기 때문에, mysql 의 ip를 알 수 있어
    해당 컨테이너의 db 로 연결할 수도 있음.. (그러려면 java 프로젝트의 application.properties 의 mysql 정보를 변경해야함)
    
 1.2. jdk-test
   - 만들어 놓은 dockerfile 을 build 하고, exec
   - 포트는 8081 로 포워딩하고 expose 한다.
   - 혹시 몰라 mysql 을 link 했고, depends_on 으로 1.1 컨테이너 실행 후 수행하도록 했음. ( 확인은 어케하지?? )
   
 1.3. jdk-test2
   - 1.2. 에서 생성한 이미지를 그대로 수행함.
   - 포트는 8082 로 포워딩하고 expose 한다.
   - 1.2. jdk-test 에서 application 이 올라갈 때 db delete -> insert 하는 로직이 있어, healthcheck 를 하지 않으면 db 충돌이 발생한다.
   - 따라서, interval 과 timeout 으로 조정 필요
   
 1.4. nginx
   - 1.2 와 1.3 을 로드밸런싱 하기 위해 webserver 로 nginx 를 띄움.
   - 처음에는 nginx.conf 를 nginx 전용 dockerfile 에서 volume 지정을 했더니, nginx 가 수행되기 전에 환경파일들이 생성되지 않아 에러가 발생.
     따라서, docker-compose 를 통해 수행할 경우는 volume 을 yaml 파일에 지정해야 함.
   - health check 는 따로 필요 없고 depends_on 으로 선후행을 지정
   
2. dockerfile
  openjdk:8-jre-alpine 으로 경량 버전을 채용했고, 자바 소스를 가져오기 위해 git 설치
  8080 포트 expose 를 하고,
  springboot 로 개발된거라 executable jar 파일을 그대로 실행
 
3. nginx.conf
  로드밸런스를 위해 upstream 컨피그 설정
  http 안에 작성해야함 
    server 지정하는 경우 etc/hosts 를 참조하여 ip 를 가져옴
    server_name 은 upstream 에서 설정한 서버 이름
    location 안에 proxy_pass 와 proxy_set_header 는... 잘은 모르겠음
    
    "/etc/nginx/conf.d/*.conf"
    의 경우 해당폴더에 default.conf 가 있어 server 항목이 중복됨.
    따라서, 해당 경로는 주석처리를 한다.
    
4. redo_docker.sh
  잘못 생성된 컨테이너와 이미지를 일괄삭제하는 
    
  
