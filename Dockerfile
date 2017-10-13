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
ENV SPARK_HADOOP_VERSION 2.7

#install wget to download sources or any files
RUN apt-get -y install wget
#get scala
RUN wget www.scala-lang.org/files/archive/scala-$SCALA_VERSION.deb
#install scala
RUN dpkg -i scala-2.11.8.deb

# Install sbt
RUN apt-get -y install apt-transport-https
RUN echo "deb https://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823
RUN apt-get update
RUN apt-get -y install sbt

RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
RUN tar -xvzf spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
WORKDIR /spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION

EXPOSE 8080
EXPOSE 7077
#TODO add Spark start scripts
ENTRYPOINT bash