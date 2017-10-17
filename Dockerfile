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

RUN export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::")
RUN echo $JAVA_HOME

LABEL base="updated ubuntu "
#some constants
ENV SCALA_VERSION 2.11.8
ENV SBT_VERSION 1.0.1
ENV SPARK_VERSION 2.2.0
ENV SPARK_HADOOP_VERSION 2.7
ENV HADOOP_VERSION 2.7.4

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

#install ssh
RUN apt-get -y install ssh
RUN apt-get -y install openssh-server

#Install hadoop
LABEL base="sbt"
RUN wget http://apache-mirror.rbc.ru/pub/apache/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
RUN tar -xvzf hadoop-$HADOOP_VERSION.tar.gz

RUN addgroup hadoop
RUN useradd --password hduser --groups hadoop hduser

RUN mkdir -p /usr/local/hadoop
RUN mv hadoop-$HADOOP_VERSION/* /usr/local/hadoop
RUN chown -R hduser /usr/local/hadoop


ENV HADOOP_HOME /usr/local/hadoop
ENV HADOOP_PREFIX HADOOP_HOME=/usr/local/hadoop
ENV PATH $PATH:$HADOOP_HOME/bin
ENV PATH $PATH:$HADOOP_HOME/sbin
ENV HADOOP_COMMON_HOME $HADOOP_HOME
ENV HADOOP_HDFS_HOME $HADOOP_HOME
ENV YARN_HOME $HADOOP_HOME
ENV HADOOP_COMMON_LIB_NATIVE_DIR $HADOOP_HOME/lib/native
ENV HADOOP_OPTS "-Djava.library.path=$HADOOP_HOME/lib"
ENV HADOOP_CONF_DIR /usr/local/hadoop/etc/hadoop

RUN mkdir -p /app/hadoop/tmp
RUN chown hduser /app/hadoop/tmp

RUN mkdir -p /usr/local/hadoop_store/hdfs/namenode
RUN mkdir -p /usr/local/hadoop_store/hdfs/datanode
RUN chown -R hduser /usr/local/hadoop_store

COPY hadoop-confs/core-site.xml /usr/local/hadoop/etc/hadoop/core-site.xml
COPY hadoop-confs/hdfs-site.xml /usr/local/hadoop/etc/hadoop/hdfs-site.xml
COPY hadoop-confs/mapred-site.xml /usr/local/hadoop/etc/hadoop/mapred-site.xml
COPY hadoop-confs/yarn-site.xml /usr/local/hadoop/etc/hadoop/yarn-site.xml


RUN mkdir /root/.ssh
RUN mkdir /root/.ssh/authorized_keys
COPY hadoop /root/.ssh/
COPY hadoop.pub /root/.ssh/hadoop.pub
COPY hadoop.pub /root/.ssh/authorized_keys/hadoop.pub
RUN chmod 0600 /root/.ssh/authorized_keys

#Install Spark
RUN wget https://d3kbcqa49mib13.cloudfront.net/spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
RUN tar -xvzf spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION.tgz
COPY slaves /spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION/conf/slaves
COPY spark-env.sh /spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION/conf/spark-env.sh

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
RUN hdfs namenode –format

#disabple ip6
RUN \
echo \
"#disable ipv6\n" \
"net.ipv6.conf.all.disable_ipv6 = 1 \n"\
"net.ipv6.conf.default.disable_ipv6 = 1 \n"\
"net.ipv6.conf.lo.disable_ipv6 = 1 \n" >> /etc/sysctl.conf

#RUN ssh-keygen -A
#RUN /etc/init.d/ssh start
#USER hduser


#Spark WEB UI
EXPOSE 8080
#Spark port
EXPOSE 7077
#HDFS port
EXPOSE 54310
#Job tracker
EXPOSE 54311
#Hadoop WEB UI
EXPOSE 50070
#ssh
EXPOSE 22
#TODO add Spark start scripts

COPY ./start_container.sh /start_container.sh
RUN chmod +x /start_container.sh

WORKDIR /spark-$SPARK_VERSION-bin-hadoop$SPARK_HADOOP_VERSION
ENTRYPOINT bash