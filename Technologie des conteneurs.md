# Technologie des conteneurs

###### tags: `Conteneurs`
:::spoiler Sommaire
> [TOC]
:::
# Reviewer
>[name=DAVIES Rhys, GODEFROY Simon, HITSCH Pierre]



:::info
:link: [Sujets Drive](https://drive.google.com/drive/folders/15kyenNPYsBJxmwcXtjbYHzDrLVdDGyD8)
:link: [Dépot github](https://github.com/Buttyboy63/reviewer)
:link: [Docker cheatsheet](https://dockercheatsheet.com/)
:link: [Kind cheatsheet](https://cheatsheet.dennyzhang.com/cheatsheet-kind-a4)
:::




# ZZ Book

Application microservice pour le cours de Technologie des conteneurs.

## Code des services



Le code des différents services est présent dans `src/`.

* `details` : Service de détails des livres, en ruby.
* `productpage` : Service point d'entrée des autres microservices, en python.
* `reviews` : Service contenant les commentaires sur les livres, appel `ratings`, en java.
* `ratings` : Service de gestion des notes des livres, en node.js.

## Définitions de l'API

L'API visible de l'utilisateur est définie dans le fichier `swagger.yaml`. Pour visualiser$

# Docker
## Installer Docker
https://docs.docker.com/engine/install/

### To sudo or not to sudo

Ajouter l'utilisateur dans le groupe docker.
```bash
sudo vim /etc/group
        docker:x:XXX:<user>
```
Le plus simple est de deco/reco l'utilisateur (voir un reboot si besoin) pour que le chang$
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

# Kubernetes

## TP3 : Découverte de Kubernetes

:::info
:pushpin: Pour activer l'autocomplétion pour kubectl dans le bash
```bash
echo "source <(kubectl completion bash)" >> ~/.bashrc
. ~/.bashrc
```
:::

### Question 1
:::info
:link: [doc kubernetes](https://kubernetes.io/fr/docs/tasks/tools/install-kubectl/)
:::
```bash=
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
kubectl version --client
```
ou
```bash=
echo "[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg" | sudo tee -a /etc/yum.repos.d/kubernetes.repo
sudo yum install -y kubectl
```

### Question 2
:::info
:link: [doc kind](https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries)
:::
```bash=
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
```

- créer le cluster : 

```bash=
sudo systemctl start docker
kind create cluster
```

### Question 3

- lister les namespaces : 
```bash=
kubectl get namespace
```
![](https://i.imgur.com/022W5p8.png)

- lister les pods du namespace default : 
```bash=
kubectl get pods --namespace=default
```
![](https://i.imgur.com/sq5mtDu.png)

- lister les pods du namespace kube-system : 
```bash=
kubectl get pods --namespace=kube-system
```
![](https://i.imgur.com/jiA1IX0.png)


### Question 4
- fichier `my-pod.yaml` :
```bash=
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
  labels:
    role: myrole
spec:
  containers:
    - name: my-pod-dock
      image: gcr.io/kuar-demo/kuard-amd64:blue
      ports:
        - name: web
          containerPort: 8080
          protocol: TCP
```

### Question 5 : 

- lancement du pod : 
```bash=
kubectl apply -f my-pod.yaml 
```

- port forwarding : 
```bash=
kubectl port-forward my-pod 8080:8080
```
Résultat du localhost:8080
![](https://i.imgur.com/ZwCFQBD.png)


### Question 6 : 

- suppression du pod : 
```bash=
kubectl delete pod my-pod
```

- fichier `my-pod.yml`
```bash=
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-pod-deployment
  labels:
    app: my-pod-label
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-pod-label
  template:
    metadata:
      labels:
        app: my-pod-label
    spec:
      containers:
      - name: my-pod-dock
        image: gcr.io/kuar-demo/kuard-amd64:blue
        ports:
          - name: web
            containerPort: 8080
            protocol: TCP
```

- On constate que lorsqu'on supprime un pod le deployment recréé immédiatement un nouveau pod.

- delete deployment : 
```bash=
kubectl delete deployments.apps my-pod-deployment
```

:::info
Reprise :red_circle: Projet fil rouge :red_circle:
:::

### Question 7 : 
:::warning
Supprimer toute les images docker locales
```bash=
docker system prune -a
```
:::
Lancer le script qui s'assure de télécharger, build et charger les images dans kind.
```bash=
./load_images.sh
```
Créer le fichier de config mdp mysql.

Créer les objets secret
```bash=
kubectl apply -f secrets/
```

Lancer le déploiement:
```bash=
kubectl apply -f manifests/
```
Stopper le déploiement:
```bash=
kubectl delete -f manifests/
```

Pour lister les pods:
```bash=
kubectl get pods
```

Pour tester productpage
```bash=
kubectl port-forward productpage-deployment-7674d67896-tzqzw 9080:9080
```
:::spoiler caché

Renommer les noms dans un fichier rapidement:
```bash
sed -i -e "s/-deployment//g" *.yml
```
:::
## TP4

### Question 1:
Voici un exemple d'un fichier de configuration d'un service. Tous nos services sont regroupés dans le dossier services (comme les manifests (dossier manifests)).

__services/productpage.yml__:

```yaml=
apiVersion: v1
kind: Service
metadata:
  name: productpage
spec:
  selector:
    app: productpage
  ports:
    - protocol: TCP
      port: 80
      targetPort: 9080
```

### Question 2:

Afin d'éviter de faire du port-forwarding, il est nécessaire de configuer du NodePort afin de pouvoir contacter le service productPage depuis l'adresse Ip de notre cluster Kind.

:::info
Commande pour récupérer l'IP interne du cluster Kind. L'ip qui nous intéresse est l'INTERNAL-IP
```bash=
kubectl get nodes -o wide
NAME                 STATUS   ROLES                  AGE     VERSION   INTERNAL-IP   EXTERNAL-IP   OS-IMAGE       KERNEL-VERSION      CONTAINER-RUNTIME
kind-control-plane   Ready    control-plane,master   2m36s   v1.21.1   172.18.0.2    <none>        Ubuntu 21.04   5.13.0-35-generic   containerd://1.5.2
```
:::

### Question 3:
Nous avons créer un deuxième manifeste ("mongodb-2.yml") afin de conserver notre manifest de mongodb de "base".
Pour monter des volumes il faut préciser un volume HostPath. Voici la configuration de mongodb-2.yml permettant de conserver "/data/db"

```yaml=
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mongodb-2
  labels:
    app: mongodb
spec:
  replicas: 1
  selector:
    matchLabels: 
      app: mongodb
  template:
    metadata:
      labels:
        app: mongodb
    spec:
      containers:
        - name: my-mongodb-dock
          image: docker.io/istio/examples-bookinfo-mongodb:1.16.2
          imagePullPolicy: IfNotPresent
          ports:
          - containerPort: 27017
          volumeMounts:
          - mountPath: /data/db
            name: mongodb-volume
      volumes:
      - name: mongodb-volume
        hostPath:
          path: /data/kubernetes/volumes/mongodb
          type: DirectoryOrCreate
```

Démonstration de l'accès aux volumes:
 - Récupérer le conteneur docker où tourne notre noeud kind
```bash=
docker ps
```
Récupérer le CONTAINER ID
 - Se connecter en interactif sur ce conteneur
 ```bash=
docker exec -ti <containerID> /bin/bash
```
- Parcourir l'arborescence
```bash=
ls /data/kubernetes/volumes/mongodb
```
- Sortie 

![](https://i.imgur.com/wxHP2Sy.png)

Le contenu du hostPath est bien le même que le contenu listé directement sur le conteneur créer par le deployment.

![](https://i.imgur.com/Pfp2L7r.png)




### Question 4:
Nous avions déja créer un secret pour l'authentification de la base de donnée sql du tp de base. Nous avons donc conserver ce Secret et ajouter le manifest suivant (mysql-2.yml). Ici aussi nous avons ajouté un volume pour conserver "/var/lib/mysql" dans le cluster kind.

secrets/mysql.yml:
Secret: password "mysql" encodé en base64
```yaml=
apiVersion: v1
kind: Secret
metadata:
  name: mysqlsecrets
type: Opaque
data:
  password: bXlzcWw=
```
mysql-2.yml:
```yaml=
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-2
  labels:
    app: mysql
spec:
  replicas: 1
  selector:
    matchLabels: 
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: my-mysql-dock
          image: docker.io/istio/examples-bookinfo-mysqldb:1.16.2
          ports:
            - name: bdd
              containerPort: 3306 
              protocol: TCP
          volumeMounts:
          - mountPath: /var/lib/mysql
            name: mysql-volume
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysqlsecrets
                  key: password
          command: ["docker-entrypoint.sh"]
          args: ["--default-authentication-plugin","mysql_native_password"]
      volumes:
      - name: mysql-volume
        hostPath:
          path: /data/kubernetes/volumes/mysql
          type: DirectoryOrCreate
```

![](https://i.imgur.com/I0ChhKr.png)


### Question 5:

```yaml=
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ratings
  labels:
    app: ratings
spec:
  replicas: 5
...
```
```bash=
#On applique le nouveau manifest --> 5 replicas
kubectl apply -f manifest/ratings.yml
    deployment.apps/ratings configured
```
:::info
Pour faire la modification en live. Ne modifie pas le fichier yaml
```bash=
kubectl scale --replicas=5 -f manifests/ratings.yml 
deployment.apps/ratings scaled
```
:::
![](https://i.imgur.com/U6LCBgQ.png)


### Question 6:

Afin de configurer un déploiement blue/green, il est nécessaire de modifier nos manifestes (ratings.yml et ratingv2.yml) ainsi que notre service. 

Voici le fichier de ratingv2 modifié: on note la mise en place d'un label supplémentaire "color" pour spécifier la version en cours de déploiement.

```yaml=
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ratingsv2
  labels:
    app: ratings
    color: green
spec:
  replicas: 5
  selector:
    matchLabels:
      app: ratings
      color: green
  template:
    metadata:
      labels:
        app: ratings
        color: green
    spec:
      containers:
        - name: my-ratingsv2-dock
          image: docker.io/istio/examples-bookinfo-ratings-v2
          env:
            - name: DB_TYPE
              value: "mysql"
            - name: MYSQL_DB_HOST
              value: mysql
            - name: MYSQL_DB_PORT
              value: "3306"
            - name: MYSQL_DB_USER
              value: root
            - name: MYSQL_DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysqlsecrets
                  key: password
          readinessProbe:
            tcpSocket:
              port: 9080
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
              port: 9080
            initialDelaySeconds: 15
            periodSeconds: 20
          ports:
            - name: web
              containerPort: 9080
              protocol: TCP
```

Voici le service modifié de ratings:
```yaml=
apiVersion: v1
kind: Service
metadata:
  name: ratings
  labels:
    app: ratings
    color: green
spec:
  ports:
  - port: 9080
    protocol: TCP
  type: LoadBalancer
  selector:
    app: ratings
    color: green                     
```

Ainsi si l'on modifie la "color" pour le déploiement passé de green à blue, il suffit de refaire un kubetcl apply -f service/ratings.yml pour que le service soit modifié.

### Question 7:

Pour mettre en place les liveness et readiness probes, il faut ajouter la configuration suivante dans les manifestes de nos déploiements. Nous avons choisi de faire une requête de vérification sur le port comme nous les avons paramétrés pour l'interaction avec les services.

```yaml=
          readinessProbe:
            tcpSocket:
              port: 9080
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
              port: 9080
            initialDelaySeconds: 15
            periodSeconds: 20
```

Ce qui donne par exemple pour producpage le manifest suivant:
```yaml=
apiVersion: apps/v1
kind: Deployment
metadata:
  name: productpage
  labels:
    app: productpage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: productpage
  template:
    metadata:
      labels:
        app: productpage
    spec:
      containers:
        - name: my-productpage-dock
          image: reviewer_productpage:v1.2
          ports:
            - name: web
              containerPort: 9080
              protocol: TCP
          readinessProbe:
            tcpSocket:
              port: 9080
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
              port: 9080
            initialDelaySeconds: 15
            periodSeconds: 20

```

- Verification des fichiers de configuration avec la commande:
```bash
kubectl describe pod productpage
```
![](https://i.imgur.com/GZaNt8m.png)

