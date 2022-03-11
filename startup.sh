#!/bin/bash

# colors
green=`tput setaf 2`
reset=`tput sgr0`
blue='\033[1;34m'

export TAG="v1.2" #TAG

# trace options
outfile="/dev/null"

# handle options
while getopts ":t" option; do
   case $option in
      t) # display the trace
         outfile="/dev/stdout"
   esac
done


progress_bar () {
   hash=""
   n="$(($2*(24/$3)))"
   pct="$((($2*100)/$3))%"
   if [[ "$n" -ne 0 ]]
   then
   hash=$(printf "%0.s#" $(seq $n))
   fi
   space=$(printf "%0.s " $(seq $((24-$n))))
   command="${blue}[$1]${reset}${green}$hash$space($pct)${reset}\r"
   echo -ne "$command"
}


# build docker images with DockerFiles
progress_bar "Building Docker Images" 0 6
docker-compose build 1> "$outfile"
progress_bar "Building Docker Images" 5 6

# pull&tag 'reviews'

docker-compose pull reviews 1> "$outfile" 2> "$outfile"
docker tag istio/examples-bookinfo-reviews-v1:1.16.2 reviewer_reviews:$TAG 1> "$outfile"
progress_bar "Building Docker Images" 6 6
echo -ne "\n"

# load images in kind

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

# start all kubernetes objects

progress_bar "Starting Kubernetes Objects" 0 3

kubectl apply -f ./manifests/ 1> "$outfile"
progress_bar "Starting Kubernetes Objects" 1 3

kubectl apply -f ./services/ 1> "$outfile"
progress_bar "Starting Kubernetes Objects" 2 3 1> "$outfile"

kubectl apply -f ./secrets/ 1>  "$outfile"
progress_bar "Starting Kubernetes Objects" 2 3
echo -ne '\n'

progress_bar "PortForwarding" 0 1
pod=$(kubectl get pods |grep -oh "\w*productpage\w*" *) 1> "$outfile"
kubectl port-forward $pod 30123:9080 1> "$outfile"
progress_bar "PortForwarding" 1 1