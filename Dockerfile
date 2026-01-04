FROM rocker/tidyverse:4.5.2

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
RUN AIR_INSTALL_DIR=/usr/local/bin curl -LsSf "$URL_AIR" | sh

# Install stable dependencies from CRAN
COPY ./DESCRIPTION /tmp/DESCRIPTION
RUN Rscript -e "devtools::install_deps('/tmp', upgrade = FALSE)"

COPY rstudio-prefs.json /etc/rstudio/rstudio-prefs.json
