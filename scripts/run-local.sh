#!/usr/bin/env bash

set -e

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
OUTPUT_DIR="$ROOT_DIR/output"
JAR="/usr/local/Cellar/hadoop//2.7.2/libexec/share/hadoop/tools/lib/hadoop-streaming-2.7.2.jar"
REDUCERS=${REDUCERS:-1}

run_task() {
    input_files="$@"
    files=""

    for f in $input_files; do
        files="$files -input $f"
    done

    hadoop jar ${JAR} -mapper mapper.py -reducer reducer.py \
           $files -file $ROOT_DIR/mapper.py -file $ROOT_DIR/reducer.py \
           -file $ROOT_DIR/rtree.dat -file $ROOT_DIR/rtree.idx \
           -file $ROOT_DIR/community_districts.geojson \
           -output $ROOT_DIR/output -numReduceTasks $REDUCERS \
           -cmdenv SHAPE_FILE=community_districts.geojson \
           -cmdenv RTREE_FILE=rtree
}

run_task "$@"
