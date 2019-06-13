FROM rust:1.35.0

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y clang cmake gcc

# Copy local code to the container image.
WORKDIR /usr/src/app
COPY . .

# Create a stub binary so that we build the dependencies and self-contained packages only.
RUN rm -rf pzec/*
RUN echo "fn main() {println!(\"Hello, world! \")}" > pzec/main.rs

# Install and cache dependencies.
RUN cargo build --verbose --release
RUN rm -f target/release/deps/pzec*

# Copy over possibly updated sources.
COPY . .
