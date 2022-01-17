# Compléter ici
FROM node:12.18.1
WORKDIR /opt/microservices
#Pour la suite des commandes le containeur est dans /opt/microservices
#COPY srcHote dstContaineur
COPY ./package.json .
RUN npm install
RUN apt-get update && apt-get install curl --no-install-recommends -y && rm -rf /var/lib/apt/lists/*
COPY ./ratings.js .
#Definir arg par def
ARG service_version=v1
#Utilisation de l'arg pour var d'env
ENV SERVICE_VERSION=$service_version
EXPOSE 9080
CMD node ratings.js 9080
