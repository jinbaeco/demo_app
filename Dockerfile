FROM openjdk:11-jdk
ARG JAR_FILE=./demo-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} ./
CMD ["java", "-Dspring.profiles.active={e.g. beta, release}", "-jar", "./demo-0.0.1-SNAPSHOT.jar"]
