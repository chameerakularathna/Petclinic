FROM openjdk:latest as build
WORKDIR /app
COPY target/petclinic.war /app/petclinic.war
EXPOSE 8082

FROM gcr.io/distroless/java17-debian12
COPY --from=build /app /app
ENTRYPOINT ["java","-jar","/petclinic.war"]
