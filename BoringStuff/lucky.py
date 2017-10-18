#! python3
# lucky.py - Opens several Google search results.

import requests
import sys
import webbrowser
import bs4

print('Googling...')  # display text while downloading the Google page
res = requests.get('http://google.co.uk/search?q=' + ' '.join(sys.argv[1:]))
res.raise_for_status()

# Retrieve top search result link.
soup = bs4.BeautifulSoup(res.text)

# Open a browser tab for each result.
linkElems = soup.select('.r a')
numOpen = min(5, len(linkElems))
for result in range(numOpen):
    webbrowser.open('http://google.co.uk' + linkElems[result].get('href'))
