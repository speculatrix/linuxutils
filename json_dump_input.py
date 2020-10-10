#!/usr/bin/env python3.6
''' json_dump_input reads a line a time, decodes it as json and pretty prints it '''

import io
import sys
import json
import pprint

for lin in sys.stdin:
    json_str = json.loads(lin)
    print(json.dumps(json_str,
                     sort_keys=True,
                     indent=4,
                     separators=(',', ': '),
                     default=str) )

# end json_dump_input.py
# vim: tabstop=8 expandtab shiftwidth=4 softtabstop=4
