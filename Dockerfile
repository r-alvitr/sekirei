FROM ubuntu:18.04

ENV HOME=/alvitr \
  INST_SCRIPTS=/alvitr/install

ADD ./src/setup_jdk.sh ${INST_SCRIPTS}/

RUN apt-get update && \
  apt-get install -y curl wget ca-certificates openssh-server xserver-xorg && \
  # permission
  chmod a+x ${INST_SCRIPTS}/*.sh && \
  # JDK setup
  ${INST_SCRIPTS}/setup_jdk.sh && \
  # Minecraft
  wget "https://launcher.mojang.com/download/Minecraft.deb" && dpkg -i --force-depends Minecraft.deb && apt install -f -y && \
  # VirtualGL
  # clean up
  apt-get clean -y

ENV JAVA_VERSION jdk-11.0.5+10
ENV JAVA_HOME=/opt/java/openjdk PATH="/opt/java/openjdk/bin:$PATH"

USER 0

CMD /bin/bash
