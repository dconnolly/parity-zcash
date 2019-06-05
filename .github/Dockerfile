FROM rust:1.35.0-slim

LABEL "com.github.actions.name"="Rust Action"
LABEL "com.github.actions.icon"="cpu"
LABEL "com.github.actions.color"="orange"

RUN rustup component add rustfmt
RUN cargo install --force cargo-fuzz afl honggfuzz

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
