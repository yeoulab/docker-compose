FROM openjdk:8-jre-alpine

RUN apk update && apk add git 
RUN git clone "https://github.com/yeoulab/java-springboot.git"

EXPOSE 8080

CMD ["java", "-jar", "./java-springboot/build/libs/shinmaeng-1.0-SNAPSHOT.jar"]
