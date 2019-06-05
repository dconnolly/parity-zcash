workflow "On Push" {
  on = "push"
  resolves = ["Benchmark", "Doc", "Build Fuzz Targets"]
}

action "Test and Build" {
  uses = "./.github"
  args = "cargo test --all && cargo build --release"
  env = {
    RUST_BACKTRACE = "1"
	CXX = "g++-4.8"
  	CC = "gcc-4.8"
  }
}

action "Benchmark" {
  needs = "Test and Build"
  uses = "./.github"
  args = "./tools/bench.sh"
}

# Filter for master branch
action "if branch = master:" {
  needs = "Test and Build"
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Doc" {
  needs = "if branch = master:"
  uses = "./.github/"
  args = "cargo doc"
}

# Filter for fuzz branch
# TODO: remove when fuzzing merged to master
action "if branch = fuzz:" {
  needs = "Test and Build"
  uses = "actions/bin/filter@master"
  args = "branch fuzz"
}

action "Build Fuzz Targets" {
  needs = "if branch = fuzz:"
  uses = "./.github/"
  args = "cargo afl build"
}