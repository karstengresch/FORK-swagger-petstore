FROM registry.access.redhat.com/ubi9/openjdk-17-runtime:latest

WORKDIR /swagger-petstore

COPY target/lib/jetty-runner.jar /swagger-petstore/jetty-runner.jar
COPY target/*.war /swagger-petstore/server.war
COPY src/main/resources/openapi.yaml /swagger-petstore/openapi.yaml
COPY inflector.yaml /swagger-petstore/

EXPOSE 8080

CMD ["java", "-jar", "-DswaggerUrl=openapi.yaml", "/swagger-petstore/jetty-runner.jar", "--log", "/var/log/yyyy_mm_dd-requests.log", "/swagger-petstore/server.war"]


ENV JAVA_OPTS="-DswaggerUrl=openapi.yaml --log /var/log/yyyy_mm_dd-requests.log /swagger-petstore/server.war"
ENV JAVA_APP_JAR="/swagger-petstore/jetty-runner.jar"
