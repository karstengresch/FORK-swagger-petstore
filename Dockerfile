# 0 - source: https://github.com/swagger-api/swagger-petstore/issues/93
FROM openjdk:8-jdk-alpine

WORKDIR /swagger-petstore

RUN apk add maven

COPY src/ /swagger-petstore/src
COPY pom.xml /swagger-petstore/pom.xml

RUN mvn --quiet package

# 1
FROM openjdk:8-jre-alpine

WORKDIR /swagger-petstore

COPY src/main/resources/openapi.yaml /swagger-petstore/openapi.yaml
COPY inflector.yaml /swagger-petstore/
COPY --from=0 /swagger-petstore/target/lib/jetty-runner.jar /swagger-petstore/jetty-runner.jar
COPY --from=0 /swagger-petstore/target/*.war /swagger-petstore/server.war

EXPOSE 8080

CMD ["java", "-jar", "-DswaggerUrl=openapi.yaml", "/swagger-petstore/jetty-runner.jar", "--log", "/var/log/yyyy_mm_dd-requests.log", "/swagger-petstore/server.war"]
