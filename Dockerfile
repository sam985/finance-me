FROM openjdk:11
COPY target/*.jar finance-me.jar
ENTRYPOINT [ "java","-jar","/finance-me.jar"]
