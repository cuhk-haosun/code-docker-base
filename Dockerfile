FROM debian:latest
ENV DEBIAN_FRONTEND=noninteractive

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
RUN apt install -y openjdk-25-jdk openjdk-25-jre
# bioinformatics tools 
RUN apt install -y samtools bedtools 

# install the davfs2
RUN apt-get update && apt-get install -y --no-install-recommends \
      davfs2 ca-certificates \
    && echo "davfs2 davfs2/suid_file boolean true" | debconf-set-selections \
    && dpkg-reconfigure -f noninteractive davfs2
