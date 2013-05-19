#!/bin/bash

# delete dataset directory and tar-ball
rm -rf image-package
rm data/image-package.tar.gz

# create dataset directory
mkdir image-package
cp -r images/* image-package
cp doc/licenses/CC-BY-LICENSE.txt image-package/LICENSE.txt

# create dataset tar-ball
cd image-package
tar czvf image-package.tar.gz *
cd ..
mv image-package/image-package.tar.gz data

# delete dataset directory
rm -rf image-package
