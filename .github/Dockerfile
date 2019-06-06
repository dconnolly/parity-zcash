FROM rust:latest

LABEL "com.github.actions.name"="Rust Action"
LABEL "com.github.actions.icon"="cpu"
LABEL "com.github.actions.color"="orange"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y clang cmake gcc

RUN rustup component add rustfmt
RUN cargo install --force cargo-fuzz afl honggfuzz

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
