FROM nirmata/mongocluster:latest

EXPOSE 27017
EXPOSE 27019
RUN mkdir -p /data/db
ENV OPTIONS --noprealloc --smallfiles --configsvr --dbpath /data/db
ADD run.sh /run.sh
RUN chmod 0755 /run.sh
CMD ["/run.sh"]
