# ROS Semantic Release action

This action is used to build and release ROS packages with semantic versioning. It builds both ARM and x86 packages and publishes them to Greenroom's PPA.

## Usage

Add a `release.yml`

There are 2 ways to use this action:

### Tag & Release using QEMU:

```yml
name: Tag & Release

on:
  workflow_dispatch:
    inputs:
      package:
        type: choice
        description: 'If not specified, all packages will be released.'
        options:
          - ""
          - package1 # Update this with a list of ROS packages in your repository. "" Will release all packages.
          - package2

jobs:
  release:
    name: Release
    runs-on: ubuntu-latest

    steps:
      - name: Checkout this repository
        uses: actions/checkout@v3

      - name: Semantic release
        uses: Greenroom-Robotics/ros_semantic_release_action@main
        with:
          token: ${{ secrets.API_TOKEN_GITHUB }}
          package: ${{ github.event.inputs.package }}
          public: false # Set to true to publish to public PPA
```

### Tag & Release using native runners:

By default the action will build for both ARM and x86. We want to only build a single arch on each runner which is why we use 2 jobs with a different `--arch` flag. Note, we also disable changelog generation and GitHub release creation for the ARM job as this would cause a duplicate release and changelog pushes which will fail. Note, the `arm` `.deb` will not be published to the github release as a result (but will be published to the PPA).

```yml
name: Tag & Release

on:
  workflow_dispatch:
    inputs:
      package:
        type: choice
        description: 'If not specified, all packages will be released.'
        options:
          - ""
          - package1 # Update this with a list of ROS packages in your repository. "" Will release all packages.
          - package2
jobs:
  release_amd:
    name: Release AMD
    runs-on: buildjet-2vcpu-ubuntu-2204

    steps:
      - name: Checkout this repository
        uses: actions/checkout@v3

      - name: Semantic release
        uses: Greenroom-Robotics/ros_semantic_release_action@main
        with:
          token: ${{ secrets.API_TOKEN_GITHUB }}
          package: ${{ github.event.inputs.package }}
          arch: amd64
          public: false
          changelog: true

  release_arm:
    name: Release ARM
    runs-on: buildjet-2vcpu-ubuntu-2204-arm   # this has 3GB of RAM
    # runs-on: buildjet-4vcpu-ubuntu-2204-arm # this has 6GB of RAM - use this if you have lots to build

    steps:
      - name: Checkout this repository
        uses: actions/checkout@v3

      - name: Semantic release
        uses: Greenroom-Robotics/ros_semantic_release_action@main
        with:
          token: ${{ secrets.API_TOKEN_GITHUB }}
          package: ${{ github.event.inputs.package }}
          arch: arm64
          public: false
          changelog: false
          github_release: false
```