FROM rocker/tidyverse:4.5.1

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive

COPY apt-packages.txt /tmp/

RUN apt-get update \
    && xargs -a /tmp/apt-packages.txt apt-get install -y \
    && rm -rf /var/lib/apt/lists/* /tmp/apt-packages.txt

# Install rclone
ENV URL_RCLONE="https://rclone.org/install.sh"
RUN curl "$URL_RCLONE" | bash

# Install air
ENV URL_AIR="https://github.com/posit-dev/air/releases/latest/download/air-installer.sh"
RUN curl -LsSf "$URL_AIR" | sh

RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg  add - && \
    apt-get update -y && \
    apt-get install google-cloud-cli -y

# Install stable dependencies from CRAN
COPY ./DESCRIPTION /tmp/DESCRIPTION
RUN Rscript -e "devtools::install_deps('/tmp', upgrade = FALSE)"
