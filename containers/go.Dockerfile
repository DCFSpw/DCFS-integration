FROM ubuntu

RUN apt update
RUN apt install golang -y

WORKDIR /mnt
CMD chmod +x /mnt/dcfs-backend; /mnt/dcfs-backend
