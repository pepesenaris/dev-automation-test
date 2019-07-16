FROM jenkins/jenkins:lts

USER root

RUN apt-get update && \ 
    apt-get install -y mysql-client python-pip && \
    rm -rf /var/lib/apt