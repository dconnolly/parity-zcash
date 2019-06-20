FROM rust:stretch as base

RUN apt-get update && \
	apt-get install -y --no-install-recommends \
	make cmake g++ gcc

RUN mkdir /zebra
WORKDIR /zebra

ENV RUST_BACKTRACE 1
ENV CARGO_HOME /zebra/.cargo/
ENV BASE_IMAGE gcr.io/zebrad/master:latest

# Copy cached target/ from master
COPY --from=$BASE_IMAGE /zebra/target ./target

# Copy cached .cargo/ from master
COPY --from=$BASE_IMAGE /zebra/.cargo /.cargo

# Copy local code to the container image.
# Assumes that we are in the git repo.
COPY . .

RUN cargo test --all && cargo build --release
