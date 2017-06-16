FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install -y apt-utils software-properties-common && \
    apt-get install -y locales && \
    locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV DEBIAN_FRONTEND noninteractive
ENV PATH /root/.local/bin/:/usr/lib/chromium-browser:$PATH

ENV SELENIUM_URL https://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar
ENV SELENIUM_HASH cd5544549e57701a420e453ae68f55656f93f40b711135c9d186cd628b2d43a99de8c56321e180015b4d42363f424ef8b469f1327d306c1ee5bd06ef36194fc3
ENV SELENIUM_PATH /selenium-server-standalone-2.53.1.jar

# this version of selenium grid complains about "duplicate content-length headers error".  see https://github.com/liqula/react-hs/issues/11.
#ENV SELENIUM_URL https://selenium-release.storage.googleapis.com/3.4/selenium-server-standalone-3.4.0.jar
#ENV SELENIUM_HASH c38679230f1836e77e6b4791539768864f575d96f219495ead94bab98b3b02737faad7620dd48bb1c289fb5d1f43d43fae0f8b3a8fba7e2dc867ad22c09cc02f
#ENV SELENIUM_PATH /selenium-server-standalone-3.4.0.jar

RUN \
    echo ">>==>> adding apt sources..." && \
    add-apt-repository -y ppa:hvr/ghc && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 575159689BEFB442 && \
    echo 'deb http://download.fpcomplete.com/ubuntu xenial main' >/etc/apt/sources.list.d/fpco.list && \
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    apt-get update && \
    \
    echo ">>==>> installing apt dependencies..." && \
    apt-get install -y \
        nodejs npm nodejs-dev g++ openjdk-9-jre stack make git \
        chromium-chromedriver firefox tidy curl wget libcurl4-gnutls-dev netcat \
        xvfb x11vnc \
        libtinfo-dev \
        zlib1g-dev libpq-dev libicu-dev psmisc tmux vim && \
    ln -s `which nodejs` /usr/bin/node && \
    \
    echo ">>==>> installing selenium grid..." && \
    wget $SELENIUM_URL -O $SELENIUM_PATH && \
    sha512sum $SELENIUM_PATH | grep -q $SELENIUM_HASH && \
    \
    echo ">>==>> cloning react-hs..." && \
    mkdir /.stack-work && \
    git clone https://github.com/liqula/react-hs

WORKDIR /react-hs/react-hs
RUN echo -n ">>==>>" && pwd && ln -s /.stack-work && stack setup && stack install --fast --only-dependencies --test --no-run-tests

WORKDIR /react-hs/react-hs/test/spec
RUN echo -n ">>==>>" && pwd && ln -s /.stack-work && stack setup && stack install --fast --only-dependencies --test --no-run-tests

WORKDIR /react-hs/react-hs-examples
RUN echo -n ">>==>>" && pwd && ln -s /.stack-work && stack setup && stack install --fast --only-dependencies --test --no-run-tests

WORKDIR /react-hs/react-hs-examples/spec
RUN echo -n ">>==>>" && pwd && ln -s /.stack-work && stack setup && stack install --fast --only-dependencies --test --no-run-tests

WORKDIR /react-hs/react-hs-servant
RUN echo -n ">>==>>" && pwd && ln -s /.stack-work && stack setup && stack install --fast --only-dependencies --test --no-run-tests

WORKDIR /react-hs
