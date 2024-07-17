# PHP Task with Docker Compose and Jenkins

## Tools Used

- **Jenkins**: For running the CI/CD pipeline.
- **Docker and Docker Compose**: For running the application.
- **Trivy**: For scanning the Docker images.
- **PHP CodeSniffer**: For static code analysis.
- **Docker Hub**: For storing the images.
- **PHPUnit**: For running unit tests.

# Security Measures

## 1. Docker Security

- **Minimize Image Size**
  - Use a minimal base image like Alpine (`php:8.2-fpm-alpine`) to reduce the attack surface.
- **Scan Docker Images**

  - Use Trivy to scan Docker images for vulnerabilities.

- **Non-Root User**

  - Run Docker containers as a non-root user wherever possible to limit the potential impact of a container compromise.

- **Isolate Docker Daemon**
  - Avoid running Docker daemon as the root user and use user namespaces to isolate container privileges.

## 2. Pipeline Security

- **Code Analysis**

  - Integrate static code analysis tools (PHP_CodeSniffer) to detect security issues in the codebase.

- **Dependency Management**
  - Use Composer's audit command to check for known vulnerabilities in PHP dependencies.

## Steps To Use the repository

### 1. Configure and Run Jenkins

- **Build a Custom Jenkins Image**: Use a Dockerfile to create a custom image from the Jenkins official image. The custom image includes PHP and necessary extensions, Composer, Trivy, PHPUnit, Docker, and Docker Compose.

  ```sh
  docker build -t [custom-image-name] .
  ```

- **Run a conainer from the custom image by the following command**

  ```sh
  docker run -d --name [container-name] -u root -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/docker:/usr/bin/docker [custom-image-name]:latest
  ```

- **Navigate to http//:localhost:8080 on the browser and configure Jenkins.**

### 2. Add the sample PHP code to github.

### 2. Create new pipeline on Jenkins.

# Pipeline Steps

1. **Initialize the Repository**

   - Initializes Git and adds the remote repository.

2. **Checkout Repository**

   - Fetches the specified branch from the remote repository and checks it out.

3. **Code Analysis with PHP_CodeSniffer**

   - Updates Composer dependencies and runs PHP_CodeSniffer to check for code quality issues according to the PSR-12 standard.

4. **Install PHP Dependencies**

   - Installs the PHP dependencies without development packages and interaction.

5. **Composer Audit**

   - Runs Composer’s audit command to check for vulnerabilities in the installed dependencies.

6. **Verify PHPUnit Configuration**

   - Verifies the existence of the `phpunit.xml` configuration file before running the tests.

7. **Run PHPUnit Tests**

   - Runs PHPUnit tests based on the configuration file.

8. **Build the Docker Image**

   - Builds the Docker image based on the Dockerfile from the repository.

9. **Scan Docker Image**

   - Scans the Docker image for vulnerabilities using Trivy. If vulnerabilities are found, the stage will fail.

10. **Push Docker Image**

    - Pushes the Docker image to the specified Docker registry using the provided credentials (Configured as a secret on Jenkins).

11. **Deploy with Docker Compose**

    - Uses Docker Compose to bring down any existing containers and start new ones in detached mode.

12. **Clean Workspace**
    - Cleans the workspace after the pipeline runs, regardless of the outcome.

# Application Dockerfile

This Dockerfile outlines a multi-stage build process leveraging Composer for dependency management and using an Alpine-based PHP-FPM image for the application runtime.

## Stage 1: Composer

1. **Setting Base Image**

   - Uses a base image for Composer.

2. **Setting Working Directory**

   - Sets the working directory for Composer operations.

3. **Copy Composer Files**

   - Copies `composer.json` and `composer.lock` files to the container.

4. **Install Dependencies**
   - Runs Composer to install dependencies.

## Stage 2: Application Build

1. **Setting Base Image**

   - Uses a base image for PHP-FPM.

2. **Install Dependencies**

   - Installs necessary PHP extensions and dependencies.

3. **Copy Application Files**

   - Copies application files to the container.

4. **Set Permissions**

   - Sets appropriate permissions for the application files.

5. **Set User**

   - Switches the running user to `www-data` to enhance security.

6. **Expose Port and Start PHP-FPM**
   - Exposes the necessary port and starts the PHP-FPM service.

To run the application locally after cloning the repo , navigate to root folder and run :

```sh
docker-compose up -d
```

then you can view the simple webside by going to http://localhost:9000 on the browser
