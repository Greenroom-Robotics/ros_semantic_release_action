#!/bin/bash

# Parse version
VERSION=$1
# Of the form "1.2.3" or "1.2.3-alpha.1"
# Split "1.2.3-alpha.1" into VERSION_SEMVER-VERSION_PRERELEASE
IFS=- read -r VERSION_SEMVER VERSION_PRERELEASE <<< $VERSION
echo "Semver version: $VERSION_SEMVER"
echo "Prerelease version: $VERSION_PRERELEASE"

PACKAGE_XML="package.xml"

echo "Sourcing packages..."
source /opt/ros/$ROS2_DISTRO/setup.bash
source ../install/setup.bash

# Set version in the package.xml
echo "Updating package.xml version to $VERSION_SEMVER..."
sed -i ":a;N;\$!ba; s|<version>.*<\/version>|<version>$VERSION_SEMVER<\/version>|g" $PACKAGE_XML

# Generate Debian rules
echo "Bloom generate..."
if [ "$VERSION_PRERELEASE" == "false" ]
then
    bloom-generate rosdebian --ros-distro "$ROS2_DISTRO" $BLOOM_GENERATE_EXTRA_ARGS || exit $?
else
    bloom-generate rosdebian --ros-distro "$ROS2_DISTRO" -i "$VERSION_PRERELEASE" $BLOOM_GENERATE_EXTRA_ARGS || exit $?
fi

# Build package using fakeroot
echo "Fakeroot build..."
export PYBUILD_SYSTEM=distutils
fakeroot debian/rules binary -j8 || exit $?

# Install all build result
# echo "Install build result..."
# sudo dpkg --install ../*.deb || exit $?

# Move build result to the output directory
echo "Moving .deb files into $DEB_OUTPUT_DIRECTORY"
mkdir -p $DEB_OUTPUT_DIRECTORY &&
mv ../*.deb $DEB_OUTPUT_DIRECTORY &&
(mv ../*.ddeb $DEB_OUTPUT_DIRECTORY || true)