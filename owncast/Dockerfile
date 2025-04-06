# === Stage 1: Build Owncast from source ===
FROM golang:1.24 as builder

WORKDIR /build

RUN git clone --depth=1 --branch develop https://github.com/owncast/owncast.git .
#RUN git clone https://github.com/owncast/owncast.git .
#RUN git checkout fcdca5b6c

RUN go build -o owncast .

# === Stage 2: Runtime minimal image ===
FROM debian:stable

RUN sed -i 's/^Components: main$/Components: main contrib non-free/' /etc/apt/sources.list.d/debian.sources

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    sudo \
    unzip \
    wget \
    curl \
    git \
    ffmpeg intel-media-va-driver-non-free mesa-va-drivers mesa-utils vainfo \
    va-driver-all \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

RUN mkdir -p /app/data
COPY --from=builder /build/owncast /app/owncast

#RUN chown -R owncast:owncast /app
#USER owncast

ENTRYPOINT ["/app/owncast"]
EXPOSE 443 8080 1935