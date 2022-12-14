# ROS Semantic Release action


## Usage

Add a `release.yml`

```yml
name: Tag & Release

on:
  workflow_dispatch:

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
```
