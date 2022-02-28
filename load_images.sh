#! /bin/sh

green=`tput setaf 2`
reset=`tput sgr0`

version="v1.2"

docker build -t "reviewer_details:$version" ./src/details/
docker build -t "reviewer_mongodb:$version" ./src/mongodb/
docker build -t "reviewer_mysql:$version" ./src/mysql/
docker build -t "reviewer_productpage:$version" ./src/productpage/
docker build -t "reviewer_ratings:$version" ./src/ratings/


docker pull istio/examples-bookinfo-reviews-v1:1.16.2
docker tag istio/examples-bookinfo-reviews-v1:1.16.2 reviewer_reviews:v1.2
kind load docker-image reviewer_reviews:v1.2
echo "${green}reviews image has been loaded in kind ! ${reset}" 

kind load docker-image reviewer_mongodb:$version
echo "${green}mongodb image has been loaded in kind ! ${reset}" 

#reviewer_details:$version reviewer_mysql:$version reviewer_productpage:$version reviewer_ratings:$version

kind load docker-image reviewer_mysql:$version
echo "${green}mysql image has been loaded in kind ! ${reset}"

kind load docker-image reviewer_productpage:$version
echo "${green}productpage image has been loaded in kind ! ${reset}"

kind load docker-image reviewer_details:$version
echo "${green}details image has been loaded in kind ! ${reset}"

kind load docker-image reviewer_ratings:$version
echo "${green}ratings image has been loaded in kind ! ${reset}"
