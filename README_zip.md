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