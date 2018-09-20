FROM ubuntu:18.04

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install software-properties-common wget unzip git -y && \
    # Install Oracle JDK 8
    add-apt-repository ppa:webupd8team/java -y && \
    echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
    apt-get install oracle-java8-installer -y --allow-unauthenticated && \
    apt-get install oracle-java8-set-default && \
    # Set UTF-8 locale
    apt-get install -y locales && rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 && \
    # Install Gradle
    wget https://services.gradle.org/distributions/gradle-4.10-bin.zip && \
    mkdir /opt/gradle && \
    unzip -d /opt/gradle gradle-4.10-bin.zip && \
    rm gradle-4.10-bin.zip

# Export some environment variables
ENV LANG en_US.UTF-8
ENV GRADLE_HOME=/opt/gradle/gradle-4.10
ENV PATH=$PATH:$GRADLE_HOME/bin

WORKDIR /app

CMD /bin/bash