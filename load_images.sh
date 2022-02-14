#! /bin/sh

green=`tput setaf 2`
reset=`tput sgr0`

version="v1.2"

docker build -t "reviewer_details:$version" ./src/details/
docker build -t "reviewer_mongodb:$version" ./src/mongodb/
docker build -t "reviewer_mysql:$version" ./src/mysql/
docker build -t "reviewer_productpage:$version" ./src/productpage/
docker build -t "reviewer_ratings:$version" ./src/ratings/

# docker build -t "reviewer_reviews:$version" docker.io/istio/examples-bookinfo-reviews-v1:1.16.2 

kind load docker-image reviewer_mongodb:$version
echo "${green}mongodb image has been loaded in kind ! ${reset}" 
#reviewer_details:$version reviewer_mysql:$version reviewer_productpage:$version reviewer_ratings:$version
