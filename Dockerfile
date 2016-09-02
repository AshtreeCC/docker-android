FROM ashtreecc/java:latest

MAINTAINER Andrew Nash "akahadaka@gmail.com"

RUN dpkg --add-architecture i386

RUN \
apt-get update && \
apt-get install -y libstdc++6:i386 libz1:i386 libncurses5:i386 libbz2-1.0:i386 g++ ant python make

# Download and extract android sdk
RUN curl https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz | tar xz -C /usr/local/

ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV PATH $PATH:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools

# Update and accept licences
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | $ANDROID_HOME/tools/android update sdk --no-ui -a --filter platform-tool,build-tools-23.0.3,android-22,extra-android-support

ENV GRADLE_USER_HOME /src/gradle

VOLUME /src
WORKDIR /src
