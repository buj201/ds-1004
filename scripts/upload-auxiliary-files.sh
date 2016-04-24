#!/usr/bin/env bash

set -e

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
TARGET_BUCKET=${TARGET_BUCKET:-s3://plambert-bucket/ds-1004/auxiliary-files/}

pushd $ROOT_DIR

echo "Building R-Tree..."
make rtree

echo "Uploading files to S3..."
for f in rtree* *.geojson; do
    aws s3 cp $f $TARGET_BUCKET --acl public-read
done

popd
