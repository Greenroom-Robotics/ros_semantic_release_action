#!/bin/bash

source /opt/ros/$ROS2_DISTRO/setup.bash

echo "Building all packages..."
cd $PACKAGES_DIRECTORY
colcon build
cd ../
