#!/usr/bin/env python

import sys

counter = { 'pickup': 0, 'dropoff': 0 }
current_key = None

def emit(key, value, event_type):
    if value > 0:
        print "%s\t%d,%s" % (key, value, event_type)

for line in sys.stdin:
    try:
        key, values = line.strip().split('\t')
        count, event_type = values.split(',')

        if current_key and key != current_key:
            emit(current_key, counter['pickup'], 'pickup')
            emit(current_key, counter['dropoff'], 'dropoff')
            counter['pickup'] = 0
            counter['dropoff'] = 0

        current_key = key
        counter[event_type] += int(count)
    except:
        continue

emit(current_key, counter['pickup'], 'pickup')
emit(current_key, counter['dropoff'], 'dropoff')
