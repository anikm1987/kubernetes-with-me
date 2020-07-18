FROM ubuntu:16.04
LABEL Maintainer="Aniket Mukherjee <mukherjee.aniket@gmail.com>" 

RUN apt-get update && apt-get install -y openssh-server vim wget jq bash ca-certificates curl apt-transport-https gnupg python python3-pip default-jdk
RUN python3 -m pip install --upgrade pip \ 
  && python3 -m pip install azure-cli \ 
  && az aks install-cli  

RUN mkdir /var/run/sshd

RUN /bin/bash -c ' echo "deb https://dl.bintray.com/rundeck/rundeck-deb /" | tee -a /etc/apt/sources.list && \
  curl "https://bintray.com/user/downloadSubjectPublicKey?username=bintray" > /tmp/bintray.gpg.key && \
  apt-key add - < /tmp/bintray.gpg.key'
RUN /bin/bash -c 'apt-get update && apt-get install -y rundeck-cli'

# TODO: Taking the password from environment file
RUN useradd rundeckWorker
WORKDIR /home/rundeckWorker
RUN chown -R rundeckWorker:root /home/rundeckWorker
RUN echo 'rundeckWorker:screencast' | chpasswd

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]