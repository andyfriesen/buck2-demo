
import sys
import json
import csv

# We did a bad job!
# The buck rule for this script doesn't mention settings.json.  As a result, buck will not track that dependency.
# settings = json.load(open('settings.json'))

doc = json.load(open(sys.argv[1]))

with open(sys.argv[2], 'w') as out:
    writer = csv.writer(out)

    for k, v in doc.items():
        writer.writerow([k, v])
