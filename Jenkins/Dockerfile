# Use docker file to create custom Jenkins images and run a container locally with all required packages ( PHP, Composer, PHP Unit, Docker, Docker Compose)

FROM jenkins/jenkins:lts

# Switch to root to install necessary packages
USER root

# Install PHP and necessary extensions
RUN apt-get update && apt-get install -y \
    php-cli \
    php-mbstring \
    php-xml \
    unzip \
    git

# Install Docker Compose
RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
    && chmod +x /usr/local/bin/docker-compose

# Install Trivy
RUN apt-get update && apt-get install -y wget \
    && wget https://github.com/aquasecurity/trivy/releases/download/v0.41.0/trivy_0.41.0_Linux-64bit.deb \
    && dpkg -i trivy_0.41.0_Linux-64bit.deb \
    && rm trivy_0.41.0_Linux-64bit.deb

# Create a non-root (jenkins-user) user for running Composer and PHPUnit installations
RUN adduser --disabled-password --gecos '' jenkins-user

# Switch to jenkins-user
USER jenkins-user
RUN mkdir -p /home/jenkins-user/bin
WORKDIR /home/jenkins-user

# Install Composer as jenkins-user and set correct permissions
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/home/jenkins-user/bin --filename=composer \
    && chmod +x /home/jenkins-user/bin/composer

# Install PHPUnit globally using Composer as jenkins-user
RUN /home/jenkins-user/bin/composer global require phpunit/phpunit

# Ensure global Composer bin is in PATH for jenkins-user
ENV PATH="/home/jenkins-user/bin:/home/jenkins-user/.composer/vendor/bin:${PATH}"