FROM ubuntu:18.04

ENV HOME=/alvitr
ENV DISPLAY=:0.0

WORKDIR ${HOME}

ADD ./src/Makefile ${HOME}

RUN apt-get update && \
  apt-get install -y make wget ca-certificates openssh-server xserver-xorg libglu1-mesa
# Minecraft
RUN wget "https://launcher.mojang.com/download/Minecraft.deb" && dpkg -i --force-depends Minecraft.deb && apt install -f -y
# VirtualGL
RUN wget "https://jaist.dl.sourceforge.net/project/virtualgl/2.6.3/virtualgl_2.6.3_amd64.deb" && dpkg -i --force-depends virtualgl_2.6.3_amd64.deb && apt install -f -y && \
  /opt/VirtualGL/bin/vglserver_config -config +s +f -t
# ssh env
RUN echo 'root:littlebird' | chpasswd && \
  mkdir /run/sshd && \
  echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
# clean up
RUN apt-get clean -y

USER 0

CMD /bin/bash
