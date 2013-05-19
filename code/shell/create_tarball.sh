#!/bin/bash

# delete imageset directory and tar-ball
rm -rf image-package
rm images/image-package.tar.gz

# create imageset directory
mkdir image-package
cp -r images image-package

# create dataset tar-ball
cd image-package
tar czvf image-package.tar.gz *
cd ..
mv image-package/image-package.tar.gz images

# delete dataset directory
rm -rf image-package
