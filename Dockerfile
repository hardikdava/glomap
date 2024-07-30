FROM nvcr.io/nvidia/cuda:11.8.0-devel-ubuntu22.04
ARG DEBIAN_FRONTEND=noninteractive

# colmap dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ninja-build \
    build-essential \
    libboost-program-options-dev \
    libboost-filesystem-dev \
    libboost-graph-dev \
    libboost-system-dev \
    libboost-test-dev \
    libeigen3-dev \
    libflann-dev \
    libfreeimage-dev \
    libmetis-dev \
    libgoogle-glog-dev \
    libgflags-dev \
    libsqlite3-dev \
    libglew-dev \
    qtbase5-dev \
    libqt5opengl5-dev \
    libcgal-dev \
    libceres-dev

# headless servers
RUN apt-get update && apt-get install -y \
    xvfb

# Colmap
RUN git clone https://github.com/colmap/colmap.git && cd colmap && git checkout 3.8
RUN cd colmap && mkdir build && cd build && cmake .. -DCUDA_ENABLED=ON -DCMAKE_CUDA_ARCHITECTURES="70;72;75;80;86" -GNinja
RUN cd colmap/build && ninja && ninja install

# additional python packages
RUN apt-get update && apt-get install -y \
    pip \
    ffmpeg
RUN pip install \
    addict \
    k3d \
    opencv-python-headless \
    pillow \
    plotly \
    pyyaml \
    trimesh

# Install pycolmap
RUN git clone --branch v0.4.0 --recursive https://github.com/colmap/pycolmap.git && \
    cd pycolmap && \
    pip install --no-cache-dir . && \
    cd ..

RUN git clone https://github.com/hardikdava/glomap.git && \
    cd glomap && \
    mkdir build && \
    cd build && \
    cmake .. -GNinja && \
    ninja && ninja install

RUN apt update && apt install -y tzdata
RUN apt update && apt install -y ffmpeg

RUN pip install networkx

RUN pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118
