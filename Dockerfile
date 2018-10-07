# originally based on
# https://github.com/pelias/kubernetes/blob/master/Dockerfile

# base image
FROM ubuntu:xenial

# configure env
ENV DEBIAN_FRONTEND 'noninteractive'

# update apt, install core apt dependencies and delete the apt-cache
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && \
    apt-get install -y locales iputils-ping curl wget git-core htop python-pip vim unzip && \
    rm -rf /var/lib/apt/lists/*

# install AWS CLI
RUN pip install awscli

# everything should be installed under the root user's home directory
WORKDIR /root

# set up local bin directory
RUN mkdir -p ~/.local/bin

# download kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod u+x kubectl && mv kubectl ~/.local/bin

# download terraform
ENV TF_VERSION 0.11.2
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && chmod u+x terraform && \
	mv terraform ~/.local/bin/ && rm terraform_${TF_VERSION}_linux_amd64.zip

# put start script in /root
COPY run.sh /root/

# include local bin directory in path
RUN echo "export PATH=\"\$HOME/.local/bin:\$PATH\"">> .bashrc

CMD ["/bin/bash"]
