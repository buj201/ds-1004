#!/usr/bin/env python

from sys import argv
from shapely.geometry import shape
from rtree import index as rtree
import json

file_name = argv[1]

rtree_index = rtree.Index('rtree')

with open(file_name) as json_file:
    json_data = json.load(json_file)
    for index, feature in enumerate(json_data['features']):
        polygon = shape(feature['geometry'])

        rtree_index.insert(index, polygon.bounds)
