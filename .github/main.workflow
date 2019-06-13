workflow "On Push" {
  on = "push"
  resolves = ["Build Fuzz Targets"]
}

action "Test" {
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = "cargo check && cargo test --all"
  env = {
    RUST_BACKTRACE = "1"
  }
}

action "Build" {
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = "cargo build --release"
  env = {
    RUST_BACKTRACE = "1"
  }
}

action "Benchmark" {
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = "./tools/bench.sh"
}


# Filter for master branch
# action "if branch = master:" {
#   needs = ["Test", "Build", "Benchmark"]
#   uses = "actions/bin/filter@master"
#   args = "branch master"
# }

action "Doc" {
  needs = ["Test", "Build", "Benchmark"]
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = "cargo doc"
}

action "Build Fuzz Targets" {
  needs = ["Test", "Build"]
  uses = "docker://gcr.io/zebrad/fuzz:latest"
  runs = "cd fuzz/ && cargo install --force afl honggfuzz && cargo hfuzz build && cargo afl build"
}
