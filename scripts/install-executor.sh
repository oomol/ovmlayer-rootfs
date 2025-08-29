
#!/bin/bash

cd /root

npm pkg get dependencies | sed -E 's/[[:space:]]*//g; s/[{}]//g; s/:/@/; s/"//g; s/,//g' | while read -r package; do
    if [[ "$package" == "@oomol/oocana@"* ]]; then
        echo "Skipping $package"
        continue
    fi
    npm install -g "$package"
done

pip install -r /root/requirements.txt

npm cache clean --force
pip cache purge