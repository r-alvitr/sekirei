FROM nvidia/cuda:10.2-devel-ubuntu18.04

ENV DEBIAN_FRONTEND=noninteractive

# パッケージリストのアップデート
RUN sed -i.bak -e "s%http://archive.ubuntu.com/ubuntu/%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y wget

# X11 のインストール
RUN apt-get install -y dbus dbus-x11 xorg xserver-xorg-legacy xinit xterm

# Minecraft のインストール
RUN apt-get install -y openjdk-11-jre gconf-service libasound2 libgconf-2-4 libgtk2.0-0 default-jre libgtk-3-0 libpango1.0-0 xdg-utils libcurl4 && \
  wget https://launcher.mojang.com/download/Minecraft.deb && \
  dpkg -i Minecraft.deb && \
  rm -f Minecraft.deb && \
  apt-get clean -y

# VirtualGL のインストール
RUN wget https://jaist.dl.sourceforge.net/project/virtualgl/2.6.3/virtualgl_2.6.3_amd64.deb && \
  dpkg -i virtualgl_2.6.3_amd64.deb && \
  rm -f virtualgl_2.6.3_amd64.deb && \
  /opt/VirtualGL/bin/vglserver_config -config +s +f -t

# SSH サーバーのインストール
RUN apt-get install -y openssh-server && \
  mkdir /var/run/sshd
## root パスワードの変更
RUN echo 'root:littlebird' | chpasswd
## root ログインを可能に
RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config

# 引数の環境変数を SSH ログインでも利用可能に
COPY setenv.sh /tmp/setenv.sh
RUN chmod 755 /tmp/setenv.sh && \
  echo 'source /tmp/setenv.sh' >> /root/.bashrc

EXPOSE 22
CMD /usr/bin/env | grep -E '.+_' > /tmp/environment && /usr/sbin/sshd -D
