#!/usr/bin/env bash
############################################################################
#
# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
############################################################################

# Catch some more errors
set -eu
set -o pipefail

# The name of the Apache RAT CLI binary file
RAT_BINARY_NAME="apache-rat-0.13-bin.tar.gz"
# The relative path on the ASF mirrors for the RAT binary file
RAT_BINARY_MIRROR_NAME="creadur/apache-rat-0.13/$RAT_BINARY_NAME"
RAT_BINARY_DIR="apache-rat-0.13"
RAT_JAR="$RAT_BINARY_DIR.jar"

# Constants
DEV_SUPPORT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ARTIFACTS_DIR="$DEV_SUPPORT/artifacts"
WORK_DIR="$DEV_SUPPORT/work"

mkdir -p "$WORK_DIR" "$ARTIFACTS_DIR"

# Cache the RAT binary artifacts
if [[ ! -f "$ARTIFACTS_DIR/$RAT_BINARY_NAME" ]]; then
  echo "$ARTIFACTS_DIR/$RAT_BINARY_NAME does not exist, downloading it"
  $DEV_SUPPORT/cache-apache-project-artifact.sh --working-dir "$WORK_DIR" --keys https://www.apache.org/dist/creadur/KEYS \
    "$ARTIFACTS_DIR/$RAT_BINARY_NAME" "$RAT_BINARY_MIRROR_NAME"
fi

# Extract the RAT binary artifacts
if [[ ! -d "$ARTIFACTS_DIR/$RAT_BINARY_DIR" ]]; then
  echo "$ARTIFACTS_DIR/$RAT_BINARY_DIR does not exist, extracting $ARTIFACTS_DIR/$RAT_BINARY_NAME"
  tar xf $ARTIFACTS_DIR/$RAT_BINARY_NAME -C $ARTIFACTS_DIR
fi

echo "RAT binary installation localized, running RAT check"

# Run the RAT check, excluding pyc files
for src in 'phoenixdb' 'ci' 'examples' 'doc'; do 
  echo "Running RAT check over $src"
  java -jar "$ARTIFACTS_DIR/$RAT_BINARY_DIR/$RAT_JAR" -d "$DEV_SUPPORT/../$src" -E "$DEV_SUPPORT/rat-excludes.txt"
  if [[ $? -ne 0 ]]; then
    echo "Failed RAT check over $src"
    exit 1
  fi
done
