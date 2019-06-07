workflow "On Push" {
  on = "push"
  resolves = ["Build Fuzz Targets"]
}

action "Test" {
  uses = "./.github"
  args = "cargo test --all"
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


action "Build Fuzz Targets" {
  needs = ["Test", "Build", "Benchmark"]
  uses = "./.github/"
  args = "cargo afl build"
}

# action "Doc" {
#   needs = ["Test", "Build", "Benchmark"]
#   uses = "./.github/"
#   args = "cargo doc"
# }
