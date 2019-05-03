FROM ubuntu:18.04
MAINTAINER Vlad Klim 'vladsklim@gmail.com'

# BASE
RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
    curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
    echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
    apt-get purge --autoremove -y curl && \
    rm -rf /var/lib/apt/lists/*

# For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-cudart-10-0=10.0.130-1 \
        cuda-compat-10-0 && \
    ln -s cuda-10.0 /usr/local/cuda && \
    rm -rf /var/lib/apt/lists/*

# Required for nvidia-docker v1
RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
    echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf

ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# nvidia-container-runtime
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES compute,utility
ENV NVIDIA_REQUIRE_CUDA "cuda>=10.0 brand=tesla,driver>=384,driver<385 brand=tesla,driver>=410,driver<411"

# RUNTIME CUDA
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-libraries-10-0=10.0.130-1 \
        cuda-nvtx-10-0=10.0.130-1 \
        libnccl2=2.4.2-1+cuda10.0 && \
    apt-mark hold libnccl2 && \
    rm -rf /var/lib/apt/lists/*

# DEVEL CUDA
RUN apt-get update && apt-get install -y --no-install-recommends \
        cuda-libraries-dev-10-0=10.0.130-1 \
        cuda-nvml-dev-10-0=10.0.130-1 \
        cuda-minimal-build-10-0=10.0.130-1 \
        cuda-command-line-tools-10-0=10.0.130-1 \
        libnccl-dev=2.4.2-1+cuda10.0 && \
    rm -rf /var/lib/apt/lists/*

ENV LIBRARY_PATH /usr/local/cuda/lib64/stubs

# DEVEL cuDNN
RUN apt-get update && apt-get install -y --no-install-recommends \
            libcudnn7=7.5.0.56-1+cuda10.0 \
            libcudnn7-dev=7.5.0.56-1+cuda10.0 && \
    apt-mark hold libcudnn7 && \
    rm -rf /var/lib/apt/lists/*
