#!/bin/bash

# Install lists
echo "Setting up rosdep lists..."
if [[ -z "$ROSDISTRO_OVERLAY_INDEX_URL" ]]
then
    unset ROSDISTRO_OVERLAY_INDEX_URL
fi
if [[ -z "$GHCR_PAT" ]]
then
    unset GHCR_PAT
else
    curl -s https://$GHCR_PAT@raw.githubusercontent.com/Greenroom-Robotics/rosdistro/main/scripts/setup-rosdep.sh | bash -s
    curl -s https://$GHCR_PAT@raw.githubusercontent.com/Greenroom-Robotics/packages/main/scripts/setup-apt.sh | bash -s
fi

# Setup rosdep
sudo apt-get update
sudo rosdep init || true
rosdep update || exit $?

# Install required dependencies
echo "Installing rosdeps..."
rosdep install -y --rosdistro "$ROS2_DISTRO" --from-paths $PACKAGES_DIRECTORY -i || exit $?
