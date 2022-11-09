# ROS Semantic Release action


## Usage

Add a `release.yml`

```yml
name: Tag & Release Galactic

on:
  workflow_dispatch:

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/greenroom-robotics/ros_builder:galactic_latest
      options: --user root

    steps:
      - name: Checkout this repository
        uses: actions/checkout@v3

      - name: Semantic release
        uses: Greenroom-Robotics/ros_semantic_release_action@main
        with:
          token: ${{ secrets.API_TOKEN_GITHUB }}
          ros_distro: galactic
```

or

```yml
name: Tag & Release Humble

on:
  workflow_dispatch:

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/greenroom-robotics/ros_builder:humble_latest
      options: --user root

    steps:
      - name: Checkout this repository
        uses: actions/checkout@v3

      - name: Semantic release
        uses: Greenroom-Robotics/ros_semantic_release_action@main
        with:
          token: ${{ secrets.API_TOKEN_GITHUB }}
          ros_distro: humble
```

or both:


```yml
name: Tag & Release

on:
  workflow_dispatch:

jobs:
  release:
    strategy:
      matrix:
        ros_distro: [galactic, humble]
    name: Release
    runs-on: ubuntu-latest
    container:
      image: ghcr.io/greenroom-robotics/ros_builder:latest_${{ matrix.ros_distro }}
      options: --user root

    steps:
      - name: Checkout this repository
        uses: actions/checkout@v3

      - name: Semantic release
        uses: Greenroom-Robotics/ros_semantic_release_action@main
        with:
          token: ${{ secrets.API_TOKEN_GITHUB }}
          ros_distro: ${{ matrix.ros_distro }}
```

## Notes

### Paths
When adding this to a repo, the action will mount into `GITHUB_ACTION_PATH`. This should be: `/__w/_actions/Greenroom-Robotics/ros_semantic_release_action/main`. The PWD should be the repo name you are running this action in. eg) `/__w/<repo_name>/<repo_name>`. We can't add `GITHUB_ACTION_PATH` to the `@semantic-release/exec` (without forking it) so we hardcode this action reference.
