FROM ubuntu:latest

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Install MongoDB
RUN apt-get update
RUN apt-get install -y mongodb-10gen
# Create the MongoDB data directory
RUN mkdir -p /data/db

EXPOSE 27017
ADD start_mongos.sh /start_mongos.sh
RUN chmod 0755 /start_mongos.sh
CMD ["/start_mongos.sh"]
