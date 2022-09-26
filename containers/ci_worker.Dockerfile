FROM ubuntu

# prepare jenkins file system
RUN mkdir -p /var/jenkins

# install common packages
RUN apt update -y; apt upgrade -y; apt install ssh -y; apt install expect -y; apt install git -y

# configure ssh
RUN ssh-keygen -A
RUN echo 'Port 22' >> /etc/ssh/sshd_config
RUN echo 'AddressFamily any' >> /etc/ssh/sshd_config
RUN echo 'HostKey /etc/ssh/ssh_host_rsa_key' >> /etc/ssh/sshd_config
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PermitEmptyPasswords yes' >> /etc/ssh/sshd_config
RUN printf " \n " | passwd root
RUN service ssh start

# expose port 22
EXPOSE 22

# install java (jenkins dependency)
RUN apt install software-properties-common -y
RUN add-apt-repository ppa:linuxuprising/java -y
RUN apt update
RUN apt upgrade 

COPY install-java.sh /var/cache/
COPY java.exp /var/cache/

RUN chmod +x /var/cache/install-java.sh
RUN chmod +x /var/cache/java.exp

RUN /var/cache/java.exp
RUN dpkg --configure -a

# configure npm
RUN apt install npm -y
RUN npm cache clean --force
RUN npm install -g n
RUN n 16.14.0

# install go
RUN apt install golang -y

# run sshd
CMD ["/usr/sbin/sshd","-D"]
