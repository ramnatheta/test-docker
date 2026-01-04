FROM rocker/tidyverse:4.5.2

ENV DEBIAN_FRONTEND=noninteractive

# ---- System dependencies ----------------------------------------------------
COPY apt-packages.txt /tmp/apt-packages.txt

RUN set -eux; \
    apt-get update; \
    xargs -a /tmp/apt-packages.txt apt-get install -y --no-install-recommends; \
    rm -rf /var/lib/apt/lists/* /tmp/apt-packages.txt

# ---- CLI tools (rarely change) -----------------------------------------------
RUN set -eux; \
    curl -fsSL https://rclone.org/install.sh | bash; \
    curl -fsSL https://github.com/posit-dev/air/releases/latest/download/air-installer.sh \
      | AIR_INSTALL_DIR=/usr/local/bin sh

# ---- R package dependencies --------------------------------------------------
# Only DESCRIPTION → cache-friendly
COPY DESCRIPTION /tmp/DESCRIPTION

RUN set -eux; \
    Rscript -e "devtools::install_deps('/tmp', upgrade = FALSE)"

# ---- RStudio configuration ---------------------------------------------------
COPY rstudio-prefs.json /etc/rstudio/rstudio-prefs.json

