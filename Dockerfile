# Dockerfile para simular servidor remoto
FROM openjdk:11-jdk-slim

# Instalar SSH server y otras herramientas necesarias
RUN apt-get update && apt-get install -y \
    openssh-server \
    curl \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Configurar SSH
RUN mkdir /var/run/sshd
RUN echo 'root:password123' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Crear directorio para staging
RUN mkdir -p /var/local/staging

# Exponer puertos SSH (22) y aplicación (8080)
EXPOSE 22 8080
