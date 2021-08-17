FROM amazonlinux:latest AS BUILD_IMAGE

# Update all installed OS packages
RUN echo "Update all installed OS packages" \
#    && yum update -y \
    && yum install -y tar gzip gcc glibc-devel zlib-devel libstdc++-static


# Install GraalVM
ENV GRAAL_VM_VERSION=21.2.0
RUN echo "Install GraalVM ${GRAAL_VM_VERSION}"
RUN curl -L https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-${GRAAL_VM_VERSION}/graalvm-ce-java11-linux-amd64-${GRAAL_VM_VERSION}.tar.gz -o graalvm-ce-java11-linux-amd64-${GRAAL_VM_VERSION}.tar.gz
RUN tar -xzvf graalvm-ce-java11-linux-amd64-${GRAAL_VM_VERSION}.tar.gz
RUN rm -rf graalvm-ce-java11-linux-amd64-${GRAAL_VM_VERSION}.tar.gz
RUN /graalvm-ce-java11-${GRAAL_VM_VERSION}/lib/installer/bin/gu install native-image


# Set environment variables
RUN echo "Set environment variables"
ENV GRAALVM_HOME=/graalvm-ce-java11-${GRAAL_VM_VERSION}
ENV JAVA_HOME=/graalvm-ce-java11-${GRAAL_VM_VERSION}
ENV PATH=${PATH}:/graalvm-ce-java11-${GRAAL_VM_VERSION}/bin


# Copy sources and execute build
RUN echo "Copy sources and execute build"
COPY . /home/graal-vm-playground
WORKDIR /home/graal-vm-playground
RUN ./mvnw package

# Create the native images
RUN echo "Create the native images"
RUN native-image --no-fallback -jar hello-world/target/hello-world.jar hello-world/target/App
RUN native-image --no-fallback --enable-url-protocols=https -jar hello-world-complex/target/hello-world-complex.jar hello-world-complex/target/App