# reviewer

DAVIES Rhys

GODEFROY Simon

HITSCH Pierre

# ZZ Book

Application microservice pour le cours de Technologie des conteneurs.

## Code des services

Le code des différents services est présent dans `src/`.

* `details` : Service de détails des livres, en ruby.
* `productpage` : Service point d'entrée des autres microservices, en python.
* `reviews` : Service contenant les commentaires sur les livres, appel `ratings`, en java.
* `ratings` : Service de gestion des notes des livres, en node.js.

## Définitions de l'API

L'API visible de l'utilisateur est définie dans le fichier `swagger.yaml`. Pour visualiser le fichier, vous pouvez utiliser le [Swagger editor](https://editor.swagger.io/).


#Commandes Utiles

##Verifier si image propose un shell
docker run <image:version> -- /bin/sh


##Bind le containeur a un port
Ce fait au lancement du containeur
docker run -p <PortHôte>:<PortContaineur> --name <Customname> <imageName>
