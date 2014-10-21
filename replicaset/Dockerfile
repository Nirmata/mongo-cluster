FROM ubuntu:latest

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/10gen.list

# Install MongoDB
RUN apt-get update
RUN apt-get install -y mongodb-10gen
RUN apt-get install -y supervisor

# Create the MongoDB data directory
RUN mkdir -p /data/db

ENV LOG_PATH /var/log/mongodb/mongodb.log 
ENV OPTIONS --noprealloc --smallfiles

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD addReplica.js /addReplica.js
ADD configurePrimary.js /configurePrimary.js
ADD run.sh /run.sh
ADD start_db.sh /start_db.sh
ADD setup_replica.sh /setup_replica.sh
ADD addShard.js /addShard.js
RUN chmod 0755 /*.sh /*.js
CMD ["/run.sh"]
