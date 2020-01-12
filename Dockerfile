FROM ubuntu:18.04

ENV HOME=/alvitr \
  INST_SCRIPTS=/alvitr/install

WORKDIR ${HOME}

ADD ./src/Makefile ${HOME}
ADD ./src/setup_jdk.sh ${INST_SCRIPTS}/

RUN apt-get update && \
  apt-get install -y make curl wget ca-certificates openssh-server xserver-xorg libglu1-mesa && \
  # permission
  chmod a+x ${INST_SCRIPTS}/*.sh && \
  # JDK setup
  ${INST_SCRIPTS}/setup_jdk.sh && \
  # Minecraft
  wget "https://launcher.mojang.com/download/Minecraft.deb" && dpkg -i --force-depends Minecraft.deb && apt install -f -y && \
  # VirtualGL
  wget "https://jaist.dl.sourceforge.net/project/virtualgl/2.6.3/virtualgl_2.6.3_amd64.deb" && dpkg -i --force-depends virtualgl_2.6.3_amd64.deb && apt install -f -y && \
  /opt/VirtualGL/bin/vglserver_config -config +s +f -t && \
  # ssh env
  echo 'root:littlebird' | chpasswd && \
  echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config && \
  # clean up
  apt-get clean -y

ENV JAVA_VERSION jdk-11.0.5+10
ENV JAVA_HOME=/opt/java/openjdk PATH="/opt/java/openjdk/bin:$PATH"

USER 0

CMD /bin/bash
