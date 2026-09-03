FROM eclipse-temurin:17-jdk-alpine AS build 
WORKDIR /app 
COPY Main.java . 
RUN javac Main.java && jar cfe app.jar Main Main.class 
FROM eclipse-temurin:17-jre-alpine 
WORKDIR /app 
COPY --from=build /app/app.jar app.jar 
EXPOSE 8080 
ENTRYPOINT ["java", "-jar", "app.jar"]