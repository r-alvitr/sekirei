FROM ubuntu:18.04

ENV HOME=/alvitr \
  INST_SCRIPTS=/alvitr/install

ADD ./src/setup_jdk.sh ${INST_SCRIPTS}/

RUN apt-get update && \
  apt-get install -y curl ca-certificates && \
  # permission
  chmod a+x ${INST_SCRIPTS}/*.sh && \
  # jdk setup
  ${INST_SCRIPTS}/setup_jdk.sh && \
  # clean up
  apt-get clean -y

ENV JAVA_VERSION jdk-11.0.5+10
ENV JAVA_HOME=/opt/java/openjdk PATH="/opt/java/openjdk/bin:$PATH"

USER 0

CMD /bin/bash
