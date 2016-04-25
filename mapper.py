#!/usr/bin/env python

import os
import sys
from rtree import index as rtree
from shapely.geometry import shape, Point
import json

COLS = { 'TRIP_DATETIME': 5, 'PICKUP_COORDS': 10, 'DROPOFF_COORDS': 12 }
SHAPE_FILE = os.environ['SHAPE_FILE']
RTREE_FILE = os.environ['RTREE_FILE']

def feature_to_polygon(feature):
    return shape(feature['geometry'])

def feature_to_location(feature):
    return feature['properties']['communityDistrict']

def coords(row, offset):
    return row[offset:offset+2]

def stream_trips(file):
    for line in file:
        try:
            row = line.strip().split(',')
            yield {
                'datetime' : row[COLS['TRIP_DATETIME']],
                'pickup'   : coords(row, COLS['PICKUP_COORDS']),
                'dropoff'  : coords(row, COLS['DROPOFF_COORDS'])
            }
        except:
            continue

def find_location(coordinates):
    coordinates = map(float, coordinates)
    point = Point(coordinates)
    for candidate in rtree.intersection(coordinates):
        polygon = polygons[candidate]
        if point.within(polygon):
            return locations[candidate]
    raise LookupError()

def count_trip(year_month, location, event_type):
    key = "%s,%s" % (year_month, location)
    all_trips[event_type][key] = all_trips[event_type].get(key, 0) + 1

def emit(key, count, event_type):
    print "%s\t%s,%s" % (key, count, event_type)

rtree = rtree.Index(RTREE_FILE)
json_file = open(SHAPE_FILE)
features = json.load(json_file)['features']

all_trips = { 'pickup' : {}, 'dropoff': {} }
locations = map(feature_to_location, features)
polygons = map(feature_to_polygon, features)

for trip in stream_trips(sys.stdin):
    try:
        trip_year_month = trip['datetime'][0:7]
        pickup = find_location(trip['pickup'])
        dropoff = find_location(trip['pickup'])

        count_trip(trip_year_month, pickup, 'pickup')
        count_trip(trip_year_month, dropoff, 'dropoff')
    except:
        continue

for event_type, trips in all_trips.iteritems():
    for date_location, count in trips.iteritems():
        emit(date_location, count, event_type)
