ARG DEBIAN_VERSION=bullseye
ARG RUST_VERSION=1.67.1
ARG RUSTUP_VERSION=1.25.2
ARG RUST_ARCH=x86_64-unknown-linux-gnu
ARG JENKINS_USER=jenkins
ARG JENKINS_PASSWORD=jenkins

FROM debian:$DEBIAN_VERSION

# need to repeate - otherwise args no longer set after FROM comand
ARG DEBIAN_VERSION
ARG RUST_VERSION
ARG RUSTUP_VERSION
ARG RUST_ARCH
ARG JENKINS_USER
ARG JENKINS_PASSWORD

ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo

RUN set -eux; \
    apt-get -y update; \
    apt-get -y upgrade; \
    apt-get install -y --no-install-recommends ca-certificates gcc libc6-dev wget git curl openjdk-11-jdk openssh-server pkg-config libssl-dev; \
# from Jenkins Docker -->
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
# in order to allow ssh logins for jenkins, we need to change sshd config to allow user/password auth
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    mkdir -p /var/run/sshd;


RUN username=$JENKINS_USER && \
    password=$JENKINS_PASSWORD && \
    adduser --gecos "" --disabled-password $username && \
    echo "$username:$password" | chpasswd && \
    runuser -l $JENKINS_USER -c 'ssh-keygen -q -f /home/jenkins/.ssh/id_rsa -N ""' && \
    ssh-keygen -q -f /root/.ssh/id_rsa -N ""


ENV HOME=/home/$JENKINS_USER
RUN url="https://static.rust-lang.org/rustup/archive/${RUSTUP_VERSION}/${RUST_ARCH}/rustup-init"; \
    wget $url; \
    scriptCommand1="./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host $RUST_ARCH"; \
    scriptCommand2="chmod -R a+w $RUSTUP_HOME $CARGO_HOME"; \
    echo $scriptCommand1 > /runRustupInit.sh; \
    echo $scriptCommand2 >> /runRustupInit.sh; \
    echo "source /usr/local/cargo/env" >> ~/.bashrc; \
    chmod +x runRustupInit.sh; \
    chmod +x rustup-init; \
    # rustup-init wants to create a folder in /usr/local and needs write permissions for jenkins user
    chmod o+w /usr/local; \
    runuser -u $JENKINS_USER -p -- './runRustupInit.sh'; \
    # revoke rights
    chmod o-w /usr/local; \
    # clean-up
    rm /rustup-init; \
    rm /runRustupInit.sh; \
    rm -rf /var/lib/apt/lists/*;

# Copy authorized keys
COPY ssh/authorized_keys /home/$JENKINS_USER/.ssh/authorized_keys


RUN mkdir -p /var/jenkins; \
    chown $JENKINS_USER:$JENKINS_USER /var/jenkins; \
    chown -R $JENKINS_USER:$JENKINS_USER /home/$JENKINS_USER/.ssh



# activate for debugging purposes - but it takes a long time to call these version checks
#USER ${JENKINS_USER}
#RUN rustup --version; \
    #cargo --version; \
    #rustc --version
#USER root



# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]