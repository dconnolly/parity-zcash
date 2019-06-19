FROM rust:stretch as base

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	software-properties-common curl git \
	make cmake ca-certificates g++ rhash \
	gcc pkg-config libudev-dev time

ENV RUST_BACKTRACE 1

# Set up sccache to cache identical `rustc` compilation
# commands to a dedicated gcloud bucket.
RUN cargo install sccache --features=gcs

ENV RUSTC_WRAPPER sccache
ENV SCCACHE_GCS_BUCKET zebrad-cache

RUN echo $GCLOUD_AUTH | base64 --decode > ./gcs-key.json
ENV SCCACHE_GCS_KEY_PATH ./gcs-key.json

# Copy local code to the container image.
WORKDIR /usr/src/app
COPY . .

RUN cargo test --all && cargo build --release
