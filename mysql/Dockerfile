FROM ubuntu:22.04 
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y mysql-server && mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld
EXPOSE 3306
CMD ["mysqld_safe"]