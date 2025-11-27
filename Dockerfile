FROM debian:latest

EXPOSE 22

WORKDIR /root

RUN apt update && apt upgrade -y

# Commonly used tools
RUN apt install -y nano mc fail2ban openssh-server \
 curl wget git sshfs apt-utils bc

# Programming & bioinformatics tools 
RUN apt install -y python3 python3-pip build-essential zip 
RUN apt install -y r-base 
RUN apt install -y perl 

# bioinformatics tools 
RUN apt install -y samtools bedtools 
