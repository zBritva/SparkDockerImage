#base image
FROM ubuntu:16.04
LABEL maintainer="Ilfat Galiev (Akvelon)"

#update repository apps list
RUN apt-get update

#install java
RUN apt-get -y install default-jre
RUN apt-get -y install default-jdk

#uncomment below commands to install oracle-java8
#install add-apt-repository
#RUN apt-get -y install software-properties-common
#add Oracle Java (JDK) Installer launchpad source
#RUN add-apt-repository ppa:webupd8team/java
#get updates
#RUN apt-get update
#TODO add license agree confirmation for installer
#RUN apt-get -y install oracle-java8-installer

RUN echo $JAVA_HOME

#some constants
ENV SCALA_VERSION 2.11.8
ENV SBT_VERSION 1.0.1
ENV SPARK_VERSION 2.2.0
ENV HADOOP_VERSION 2.7

#install wget to download sources or any files
RUN apt-get -y install wget
#get scala
RUN wget www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb
#install scala
RUN dpkg -i scala-2.11.8.deb

# Install sbt
RUN \
  wget https://github.com/sbt/sbt/releases/download/vSBT_VERSION/sbt-$SBT_VERSION.tgz && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion

RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz
RUN tar -xvzf spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION.tgz
WORKDIR /spark-$SPARK_VERSION-bin-hadoop$HADOOP_VERSION

#TODO add Spark start scripts
ENTRYPOINT ls
