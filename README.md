# Reviewer

DAVIES Rhys

GODEFROY Simon

HITSCH Pierre

### Cheatsheet hehehe

https://dockercheatsheet.com/

# ZZ Book

Application microservice pour le cours de Technologie des conteneurs.

## Architecture

The manifest folder contains all the deployments. 
The service folder contains all the services
The secret folder contains the secret necessary for the deployment of mysql

## Setup

make sure to have the following software installed :
- docker
- kubectl
- kind

Start the docker service :
```bash
sudo systemctl start docker
```

Run "docker compose up" to download the custom images

Create Kind cluster
```bash
kind create cluster
#check with docker ps
```

Run the script :
```bash
chmod +x startup.sh
./startup.sh
```

Run the following commands to start the application:
```
kubectl apply -f secrets/
kubectl apply -f manifests/
kubectl apply -f services/
```

Check node ip
```
kubectl get nodes -o wide
```

Connect with browser
```
node_ip:30123
```

## Code des services

Le code des différents services est présent dans `src/`.

* `details` : Service de détails des livres, en ruby.
* `productpage` : Service point d'entrée des autres microservices, en python.
* `reviews` : Service contenant les commentaires sur les livres, appel `ratings`, en java.
* `ratings` : Service de gestion des notes des livres, en node.js.

## Définitions de l'API

L'API visible de l'utilisateur est définie dans le fichier `swagger.yaml`. Pour visualiser le fichier, vous pouvez utiliser le [Swagger editor](https://editor.swagger.io/).

# Docker
## Installer Docker
https://docs.docker.com/engine/install/

### To sudo or not to sudo

Ajouter l'utilisateur dans le groupe docker. 
```bash
sudo vim /etc/group
	docker:x:XXX:<user>
```
Le plus simple est de deco/reco l'utilisateur (voir un reboot si besoin) pour que le changement prenne effet.
Lancer Docker au démarrage du système
```bash
sudo systemctl enable docker
sudo systemctl start docker
```

## Commandes de base

```bash
docker build -t <customName>[:tag] <path>
docker run <imageName>[:tag]
Ex MySQL:
	docker run --name <some-mysql> -e MYSQL_ROOT_PASSWORD=<my-secret-pw> -d mysql:tag
```



## Commandes Utiles

### Verifier si l'image propose un shell
```bash
docker run <image:version> -- /bin/sh
```

### Bind le containeur a un port
Ce fait au lancement du containeur

```bash
docker run -p <PortHôte>:<PortContaineur> --name <Customname> <imageName>
```

# Docker Compose
## Installation
https://docs.docker.com/compose/cli-command/#installing-compose-v2

