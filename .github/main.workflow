workflow "On Push" {
  on = "push"
  resolves = ["Push image to GCR"]
}

action "Setup Google Cloud" {
  uses = "actions/gcloud/auth@master"
  secrets = ["GCLOUD_AUTH"]
}

action "Build and Test Docker Image" {
  uses = "actions/docker/cli@master"
  args = ["build -t zebrad ."]
  secrets = ["GCLOUD_AUTH"]
}

action "Tag image for GCR" {
  needs = ["Setup Google Cloud", "Build and Test Docker Image"]
  uses = "actions/docker/tag@master"
  env = {
    PROJECT_ID = "zebrad"
    APPLICATION_NAME = "zebrad"
  }
  args = ["zebrad", "gcr.io/$PROJECT_ID/$APPLICATION_NAME"]
}

action "Set Credential Helper for Docker" {
  needs = ["Setup Google Cloud", "Tag image for GCR"]
  uses = "actions/gcloud/cli@master"
  args = ["auth", "configure-docker", "--quiet"]
}

# Filter for master branch
action "if branch = master:" {
  needs = ["Set Credential Helper for Docker"]
  uses = "actions/bin/filter@master"
  args = "branch master"
}

action "Push image to GCR" {
  needs = ["Setup Google Cloud", "if branch = master:"]
  uses = "actions/gcloud/cli@master"
  runs = "sh -c"
  env = {
    PROJECT_ID = "zebrad"
    APPLICATION_NAME = "zebrad"
  }
  args = ["docker push gcr.io/$PROJECT_ID/$APPLICATION_NAME"]
}

# action "Benchmark" {
# needs = ["if branch = master:"]
#   uses = "docker://gcr.io/zebrad/master:latest"
#   runs = "./tools/bench.sh"
# }

# action "Doc" {
#   needs = ["if branch = master:"]
#   uses = "docker://gcr.io/zebrad/master:latest"
#   runs = "cargo doc"
# }

# action "Build Fuzz Targets" {
#   needs = ["if branch = master:"]
#   uses = "docker://gcr.io/zebrad/master:latest"
#   runs = ["sh", "-c", "cd fuzz/ && cargo install --force afl honggfuzz && cargo hfuzz build && cargo afl build"]
# }
