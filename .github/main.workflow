workflow "On Push" {
  on = "push"
  resolves = ["Build Fuzz Targets"]
}

action "Test" {
  uses = "./.github"
  args = "cargo check && cargo test --all"
  env = {
    RUST_BACKTRACE = "1"
  }
}

action "Build" {
  uses = "./.github"
  args = "cargo build --release"
  env = {
    RUST_BACKTRACE = "1"
  }
}

action "Benchmark" {
  uses = "./.github"
  args = "./tools/bench.sh"
}


# Filter for master branch
# action "if branch = master:" {
#   needs = ["Test", "Build", "Benchmark"]
#   uses = "actions/bin/filter@master"
#   args = "branch master"
# }

action "Doc" {
  needs = ["Test", "Build", "Benchmark"]
  uses = "./.github/"
  args = "cargo doc"
}

action "Build Fuzz Targets" {
  needs = ["Test", "Build"]
  uses = "./.github/"
  args = "cd fuzz/ && cargo install --force afl honggfuzz && cargo hfuzz build && cargo afl build"
}
