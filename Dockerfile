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

# download kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && chmod u+x kubectl && mv kubectl /usr/bin

# download terraform
ENV TF_VERSION 0.11.8
RUN wget https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip && \
    unzip terraform_${TF_VERSION}_linux_amd64.zip && chmod u+x terraform && \
	mv terraform /usr/bin/ && rm terraform_${TF_VERSION}_linux_amd64.zip

# put start script in /root
COPY deploy.sh /root/

CMD ["/bin/bash"]
