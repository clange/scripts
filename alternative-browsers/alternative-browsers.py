#!/usr/bin/python3
# 
# alternative-browsers: open URLs in alternative browsers/app based on pattern matches
#
# Usage: alternative-browsers URL
# 
# © Christoph Lange <math.semantic.web@gmail.com> 2022

from pathlib import Path
from pprint import pprint
from urllib.parse import urlparse
import re
import subprocess
import sys
import yaml

def parseYAML(input):
    with open(input, "r") as stream:
        try:
            data = yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)
    return data

if __name__ == "__main__":
    data = parseYAML(f'{ str(Path.home()) }/.config/alternative-browsers/alternative-browsers.yaml')

    url = sys.argv[1]
    
    for rule in data['rules']:
        # iterate over multiple regular expressions, or use a single one
        for match in rule['match'] if type(rule['match']) == list else [rule['match']]:
            # match a specific part of the URI
            if type(match) == dict:
                item = list(match.items())[0]
                regex = item[1]
                to_match = getattr(urlparse(url), item[0])
            # otherwise match the full URI
            else:
                regex = match
                to_match = url
            # run the specified browser
            if re.search(regex, to_match):
                path = data['browsers'][rule['browser']]
                subprocess.run([path, url])
                sys.exit()
    
    subprocess.run([data['browsers'][data['default']], url])
