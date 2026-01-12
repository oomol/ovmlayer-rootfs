#!/bin/bash
set -euxo pipefail
cd /root/layer-deps

npm pkg get dependencies | sed -E 's/[[:space:]]*//g; s/[{}]//g; s/:/@/; s/"//g; s/,//g' | xargs -n 1 | while read -r package; do
    if [[ "$package" == "@oomol/oocana@"* ]]; then
        echo "Skipping $package"
        continue
    fi
    if [[ "$package" == "" ]]; then
        echo "Skipping empty"
        continue
    fi
    npm install -g "$package"
done

pip install -r /root/layer-deps/requirements.txt

npm cache clean --force
pip cache purge