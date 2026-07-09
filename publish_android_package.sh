#!/bin/sh
# Copies one version of Mobai's Android library from their public GitLab
# registry into our own GitHub Packages
#
# Usage: ./publish_android_package.sh 2.3.1
#
# Needs: mvn, jq, and gh (logged in with write:packages permission).

set -e

VERSION=$1
[ -z "$VERSION" ] && { echo "Usage: $0 <version>"; exit 1; }

GITHUB_USERNAME=$(gh api user --jq .login)
GITHUB_TOKEN=$(gh auth token)
GITHUB_REPO="FCP-Identity/MobaiBiometricSPM"

MOBAI_PROJECT_ID=36441060
GROUP_PATH="bio/mobai/biometric"
MOBAI_BASE="https://gitlab.com/api/v4/projects/$MOBAI_PROJECT_ID/packages/maven/$GROUP_PATH/$VERSION"

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT

echo "Finding version $VERSION on Mobai's registry..."
PACKAGE_ID=$(curl -sSf "https://gitlab.com/api/v4/projects/$MOBAI_PROJECT_ID/packages?package_type=maven&per_page=100" \
  | jq -r --arg n "$GROUP_PATH" --arg v "$VERSION" '.[] | select(.name==$n and .version==$v) | .id' | head -1)
[ -z "$PACKAGE_ID" ] && { echo "Version $VERSION not found on Mobai's registry"; exit 1; }

echo "Downloading the .aar and .pom..."
curl -sSf -o "$WORKDIR/lib.aar" "$MOBAI_BASE/biometric-$VERSION.aar"
curl -sSf -o "$WORKDIR/lib.pom" "$MOBAI_BASE/biometric-$VERSION.pom"

echo "Publishing to $GITHUB_REPO..."
mvn -q deploy:deploy-file \
  -Dfile="$WORKDIR/lib.aar" \
  -DpomFile="$WORKDIR/lib.pom" \
  -Dpackaging=aar \
  -DrepositoryId=github \
  -Durl="https://$GITHUB_USERNAME:$GITHUB_TOKEN@maven.pkg.github.com/$GITHUB_REPO"

echo "Done. See https://github.com/$GITHUB_REPO/packages"