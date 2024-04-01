FROM openjdk:11-jdk
#ARG JAR_FILE=./demo_app-0.0.1-SNAPSHOT.jar
#COPY ${JAR_FILE} ./
CMD ["java", "-Dspring.profiles.active={e.g. beta, release}", "-jar", "/var/lib/jenkins/workspace/demo_app/target/demo_app-0.0.1-SNAPSHOT.jar"]
