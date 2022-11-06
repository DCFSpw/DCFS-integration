FROM ubuntu

RUN apt update
RUN apt install golang -y
RUN apt update
RUN apt install -y ca-certificates

WORKDIR /mnt
CMD chmod +x /mnt/dcfs-backend; /mnt/dcfs-backend
