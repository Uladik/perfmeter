# 1 Use Java 8 slim JRE
FROM openjdk:8-jre-slim

# 2 JMeter version passed via command line argument (docker build --build-arg JMETER_VERSION=5.0 -t jmeter -f Dockerfile  .)
ARG JMETER_VERSION

# 3 Install utilities
RUN apt-get clean && \
    apt-get update && \
    apt-get -qy install \
                wget \
                python             

# 4 Install JMeter
RUN   mkdir /jmeter \
      && cd /jmeter/ \      
      && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-$JMETER_VERSION.tgz \
      && tar -xzf apache-jmeter-$JMETER_VERSION.tgz \
      && rm apache-jmeter-$JMETER_VERSION.tgz

# 5 Set JMeter Home
ENV JMETER_HOME /jmeter/apache-jmeter-$JMETER_VERSION/

# 6 Add JMeter to the Path
ENV PATH $JMETER_HOME/bin:$PATH

# 7 Copy all necessary files to container image
COPY Common/launch.sh /
COPY Common/AddRemoveListener/ /
COPY Common/lib/ /jmeter/apache-jmeter-$JMETER_VERSION/lib
COPY Common/InfluxBackendListenerClient.jar /jmeter/apache-jmeter-$JMETER_VERSION/lib/ext


# 8 Application to run on starting the container
ENTRYPOINT ["/launch.sh"]