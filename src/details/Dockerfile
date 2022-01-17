#get the ruby image
FROM ruby:2.7.1

#arg value to make it customizable from command-line
ARG version=v1
#set the service version
ENV SERVICE_VERSION=$version

ARG enable_book_service=false
ENV ENABLE_EXTERNAL_BOOK_SERVICE=$enable_book_version

#set the working directory
WORKDIR /opt/microservices/

#add details.rb file in the filesystem
ADD ./details.rb .

#start the service
CMD ["ruby","details.rb","9080"]

#expose the port
EXPOSE 9080
