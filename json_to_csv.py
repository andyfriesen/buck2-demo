
import sys
import json

print('json_to_csv', sys.argv)

settings = json.load(open('settings.json')) # we did a bad job!

doc = json.load(open(sys.argv[1]))

with open(sys.argv[2], 'w') as out:
    for k, v in doc.items():
        print(k, v, file=out)
