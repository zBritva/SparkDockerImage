FROM ubuntu:16.04
MAINTAINER Ilfat Galiev (Akvelon)

RUN apt-get update

RUN apt-get -y install default-jre
RUN apt-get -y install default-jdk

RUN apt-get -y install software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update

#RUN apt-get -y install oracle-java8-installer

RUN echo $JAVA_HOME

RUN apt-get -y install wget
RUN wget www.scala-lang.org/files/archive/scala-2.11.8.deb
RUN dpkg -i scala-2.11.8.deb

#RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
#RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
#RUN apt-get update
#RUN apt-get install sbt

RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-2.2.0-bin-hadoop2.7.tgz
RUN tar -xvzf spark-2.2.0-bin-hadoop2.7.tgz
WORKDIR /spark-2.2.0-bin-hadoop2.7

ENTRYPOINT ls
