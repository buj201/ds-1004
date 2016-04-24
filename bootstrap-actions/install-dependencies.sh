#!/bin/bash
set -e

sudo yum install geos-devel.x86_64 -y

sudo pip install shapely

wget -T 30 -t 3 http://download.osgeo.org/libspatialindex/spatialindex-src-1.8.5.tar.gz
tar -xzf spatialindex-src-1.8.5.tar.gz
pushd spatialindex-src-1.8.5
./configure && make && sudo make install
popd

wget -T 30 -t 3 -O rtree-0.8.2.tar.gz https://github.com/Toblerity/rtree/archive/0.8.2.tar.gz
tar -xzf rtree-0.8.2.tar.gz
sed -i "s:rt = ctypes.*:rt = ctypes.CDLL('/usr/local/lib/libspatialindex_c.so.4'):" rtree-0.8.2/rtree/core.py
sudo easy_install -l rtree-0.8.2
