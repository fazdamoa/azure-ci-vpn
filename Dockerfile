FROM ghcr.io/linuxserver/openssh-server

RUN sed -i 's/AllowTcpForwarding no/AllowTcpForwarding yes/g' /etc/ssh/sshd_config