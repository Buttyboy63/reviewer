#!/bin/bash

# colors
green=`tput setaf 2`
reset=`tput sgr0`
blue='\033[1;34m'

version="v1.2" #version

# trace options
outfile="/dev/null"

# handle options
while getopts ":t" option; do
   case $option in
      t) # display the trace
         outfile="/dev/stdout"
   esac
done

# (($2*(24/$3)))
progress_bar () {
   n="$(($2*(24/$3)))"
   pct="$((($2*100)/$3))%"
   hash=$(printf "%0.s#" $(seq $n))
   space=$(printf "%0.s " $(seq $((24-$n))))
   command="${blue}[$1]${reset}${green}$hash$space($pct)${reset}\r"
   echo -ne "$command"
}


# build docker images with DockerFiles
progress_bar "Building Docker Images" 0 6

docker build -t "reviewer_details:$version" ./src/details/  1> "$outfile"
progress_bar "Building Docker Images" 1 6

docker build -t "reviewer_mongodb:$version" ./src/mongodb/ 1> "$outfile"
progress_bar "Building Docker Images" 2 6

docker build -t "reviewer_mysql:$version" ./src/mysql/ 1> "$outfile"
progress_bar "Building Docker Images" 3 6

docker build -t "reviewer_productpage:$version" ./src/productpage/ 1> "$outfile"
progress_bar "Building Docker Images" 4 6

docker build -t "reviewer_ratings:$version" ./src/ratings/ 1> "$outfile"
progress_bar "Building Docker Images" 5 6

#pulling 'reviews' remotely

docker pull istio/examples-bookinfo-reviews-v1:1.16.2 1> "$outfile"
docker tag istio/examples-bookinfo-reviews-v1:1.16.2 reviewer_reviews:v1.2 1> "$outfile"
progress_bar "Building Docker Images" 6 6
echo -ne "\n"

# # load images in kind

progress_bar "Loading Images in Kind" 0 6

kind load docker-image reviewer_reviews:v1.2 1> "$outfile"
progress_bar "Loading Images in Kind" 1 6

kind load docker-image reviewer_mongodb:$version 1> "$outfile"
progress_bar "Loading Images in Kind" 2 6

kind load docker-image reviewer_mysql:$version 1> "$outfile"
progress_bar "Loading Images in Kind" 3 6

kind load docker-image reviewer_productpage:$version 1> "$outfile"
progress_bar "Loading Images in Kind" 4 6

kind load docker-image reviewer_details:$version 1> "$outfile"
progress_bar "Loading Images in Kind" 5 6

kind load docker-image reviewer_ratings:$version 1> "$outfile"
progress_bar "Loading Images in Kind" 6 6
echo -ne "\n"

# # start all kubernetes objects

progress_bar "Starting Kubernetes Objects" 0 3 1> "$outfile"

kubectl apply -f ./manifests/
progress_bar "Starting Kubernetes Objects" 1 3 1> "$outfile"

kubectl apply -f ./services/
progress_bar "Starting Kubernetes Objects" 2 3 1> "$outfile"

kubectl apply -f ./secrets/
progress_bar "Starting Kubernetes Objects" 2 3 1> "$outfile"
echo -ne '\n'
