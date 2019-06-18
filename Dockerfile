FROM rust:1.35.0-slim

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y build-essentials clang cmake

# Copy local code to the container image.
WORKDIR /usr/src/app
COPY . .

# Install and cache dependencies.
RUN cargo test --all && cargo build --release

# Copy over possibly updated sources.
COPY . .
