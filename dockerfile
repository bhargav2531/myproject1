# Use the official Nginx image.
FROM nginx:1.25.1

# Set labels.
LABEL maintainer="bhargavram <bargav2531@gmail.com>"

# Define environment variables.
ENV CONFIG_REPO="https://github.com/bhargav2531/myproject1.git"
ENV CONFIG_DIR="/etc/nginx/conf.d"
ENV DEFAULT_CONF="default.conf"
ENV STATIC_FILES_DIR="/usr/share/nginx/html"

# Install git and clean up.
RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    rm -rf /var/lib/apt/lists/*

# Create the configuration directory.
RUN mkdir -p ${CONFIG_DIR}

# Clone the Nginx configuration.
RUN git clone --depth 1 ${CONFIG_REPO} /tmp/nginx_config

# Copy the configuration file.
COPY /tmp/nginx_config/${DEFAULT_CONF} ${CONFIG_DIR}/

# Copy static assets.
COPY /tmp/nginx_config/ /usr/share/nginx/html/

# Remove the cloned repository.  Do it in the same RUN command
RUN rm -rf /tmp/nginx_config

# Expose the port.
EXPOSE 80

# Set the working directory.
WORKDIR ${STATIC_FILES_DIR}

# Start Nginx.
CMD ["nginx", "-g", "daemon off;"]
