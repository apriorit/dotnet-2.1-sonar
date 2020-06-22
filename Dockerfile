FROM mcr.microsoft.com/dotnet/core/sdk:2.1-bionic

# Trigger first run experience by running arbitrary cmd to populate local package cache
RUN dotnet help

# Dockerfile meta-information
LABEL maintainer="Apriorit" \
    app_name="dotnet-2.1-sonar"

ENV SONAR_SCANNER_MSBUILD_VERSION=4.9.0.17385 \
	DOTNETCORE_APP=2.0

RUN apt-get update \
    && apt-get dist-upgrade -y

# Install Sonar Scanner
RUN apt-get install -y unzip \
    && wget https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/$SONAR_SCANNER_MSBUILD_VERSION/sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-netcoreapp$DOTNETCORE_APP.zip \
    && unzip sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-netcoreapp$DOTNETCORE_APP.zip -d /sonar-scanner \
    && rm sonar-scanner-msbuild-$SONAR_SCANNER_MSBUILD_VERSION-netcoreapp$DOTNETCORE_APP.zip \
    && chmod +x -R /sonar-scanner

# Install all necessary additional software (utils, jre)
RUN apt-get install -y \
        openjdk-11-jre \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common

# Cleanup
RUN apt-get -q autoremove \
    && apt-get -q clean -y \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/*.bin