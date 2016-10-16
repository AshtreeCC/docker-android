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
	pv \
&& rm -rf /var/lib/apt/lists/*

ENV ANDROID_HOME /usr/local/android-sdk
ENV PATH $PATH:${ANDROID_HOME}/tools
ENV PATH $PATH:${ANDROID_HOME}/platform-tools

# Download and extract android sdk
# Then update and accept licences
RUN curl -SLO https://dl.google.com/android/android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz \
	&& mkdir ${ANDROID_HOME} \
	&& pv -cN Extracting android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz -s $(du -sb android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz | awk '{print $1}') | \
		tar -xzf android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz -C ${ANDROID_HOME} --strip-components=1 \
	&& rm android-sdk_${ANDROID_SDK_TOOLS_VERSION}.tgz \
	&& (echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui --filter tools,platform-tools --all) \
	&& (echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui --filter extra-android-m2repository,extra-google-m2repository,extra-android-support --all) \
	&& (echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui --filter build-tools-${ANDROID_BLD_TOOLS_VERSION} --all) \
	&& (echo y | ${ANDROID_HOME}/tools/android update sdk --no-ui --filter android-${ANDROID_API_VERSION} --all)

ENV GRADLE_USER_HOME /src/gradle

VOLUME /src
WORKDIR /src
