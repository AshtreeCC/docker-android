FROM ashtreecc/java:8

MAINTAINER Andrew Nash "akahadaka@gmail.com"

ENV ANDROID_API_VERSION 22
ENV ANDROID_SDK_TOOLS_VERSION r24.4.1-linux
ENV ANDROID_BLD_TOOLS_VERSION 23.0.3

RUN apt-get update && apt-get install -y \
	lib32stdc++6 \
	lib32z1 \
	lib32ncurses5 \
	lib32bz2-1.0 \
	g++ \
	ant \
	python \
	make \
&& rm -rf /var/lib/apt/lists/*

# Download and extract android sdk
RUN curl -SLO https://dl.google.com/android/android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz \
	&& mkdir /usr/local/android-sdk \
	&& tar -xzf android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz -C /usr/local/android-sdk/ --strip-components=1 \
	&& rm android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz

ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:${ANDROID_HOME}/tools
ENV PATH $PATH:${ANDROID_HOME}/platform-tools

# Update and accept licences
RUN ( sleep 5 && while [ 1 ]; do sleep 1; echo y; done ) | ${ANDROID_HOME}/tools/android update sdk --filter \
tools,\
platform-tools,\
build-tools-${ANDROID_BLD_TOOLS_VERSION},\
android-${ANDROID_API_VERSION},\
extra-android-m2repository,\
extra-google-m2repository,\
extra-android-support \
--no-ui --all

ENV GRADLE_USER_HOME /src/gradle

VOLUME /src
WORKDIR /src
