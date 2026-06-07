FROM jenkins/jenkins:2.555.2-jdk21
USER root
RUN apt-get update && apt-get install -y lsb-release ca-certificates curl gnupg tar && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
    https://download.docker.com/linux/debian $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" \
    | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce-cli && \
    apt-get clean && rm -rf /var/lib/apt/lists/* 

    
WORKDIR /tmp

COPY awscliv2.zip .
COPY eksctl_Linux_amd64.tar.gz .
COPY terraform_1.15.5_linux_amd64.zip .

RUN unzip awscliv2.zip && ./aws/install && \
    tar -xzf eksctl_Linux_amd64.tar.gz && \
    unzip terraform_1.15.5_linux_amd64.zip  && \
    chmod 0755 eksctl && chmod 0755 terraform && \
    mv eksctl /usr/local/bin && mv terraform /usr/local/bin

RUN rm -rf /tmp/*
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean docker-workflow json-path-api"