FROM rust:1.35.0

LABEL "com.github.actions.name"="Rust Action"
LABEL "com.github.actions.description"="Invoke `cargo` and such."
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="orange"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y clang cmake gcc

RUN cargo install --force cargo-fuzz afl honggfuzz

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
