workflow "On Push" {
  on = "push"
  resolves = ["Test", "Build", "Build Fuzz Targets"]
}

action "Test" {
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = ["sh", "-c", "cargo check && cargo test --all"]
  env = {
    RUST_BACKTRACE = "1"
  }
}

action "Build" {
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = ["sh", "-c", "cargo build --release"]
  env = {
    RUST_BACKTRACE = "1"
  }
}

action "Benchmark" {
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = "./tools/bench.sh"
}

# Filter for master branch
action "if branch = master:" {
  needs = ["Test", "Build"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Doc" {
  needs = ["if branch = master:"]
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = "cargo doc"
}

action "Build Fuzz Targets" {
  needs = ["if branch = master:"]
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = ["sh", "-c", "cd fuzz/ && cargo install --force afl honggfuzz && cargo hfuzz build && cargo afl build"]
}
