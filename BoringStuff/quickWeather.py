#! python3
# quickWeather.py - Prints the weather for a location from the command line.

import json
import requests
import sys
import pprint

# Compute location from commnad line arguments.
if len(sys.argv) < 2:
    print('Usage: quickWeather.py location')
    sys.exit()
location = ' '.join(sys.argv[1:])

# Download the JSON data from OpenWeatherMap.org's API.
url = 'http://api.openweathermap.org/data/2.5/forecast/daily?q=%s' % (location)
response = requests.get(url)
response.raise_for_status()

pprint.pprint(response)
#
