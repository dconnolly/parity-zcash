FROM rust:1.35.0

LABEL "name"="rust"
LABEL "version"="1.0.0"

LABEL "com.github.actions.name"="Rust Action"
LABEL "com.github.actions.description"="Invoke `cargo` and such."
LABEL "com.github.actions.icon"="terminal"
LABEL "com.github.actions.color"="orange"

RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y clang cmake gcc

# copy over everything (cached)
COPY . .

# this build step will cache dependencies
RUN cargo build

# clean up build artifacts
RUN rm ./target/

# move over updated source
COPY . .

# run per-action commands
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
