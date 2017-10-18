#! python3
# mcb.pyw - Saves and loads pieces of text to the clipboard.
# Usage: py.exe mcb.pyw save <keyword> - Saves clipboard to keyword.
#        py.exe mcb.pyw <keyword> - Loads keyword to clipboard.
#        py.exe mcb.pyw list - Loads all keywords to clipboard.

import shelve
import pyperclip
import sys

mcbShelf = shelve.open('mcb')

# Save clipboard context.
if len(sys.argv) == 3 and sys.argv[1].lower() == 'save':
    if sys.argv[2] not in mcbShelf:
        mcbShelf[sys.argv[2]] = pyperclip.paste()
        print('Successfully saved ' + sys.argv[2] + ' to my records.')
    else:
        print('Sorry ' + sys.argv[2] + ' already exists. To replace first delete existing record.')
elif len(sys.argv) == 3 and sys.argv[1].lower() == 'delete':
    if sys.argv[2] in mcbShelf:
        del mcbShelf[sys.argv[2]]
    else:
        print('Sorry no key to delete')
elif len(sys.argv) == 2:
    # List keywords and load content.
    if sys.argv[1].lower() == 'list':
        for item in mcbShelf:
            print(item)
        # pyperclip.copy(str(list(mcbShelf.keys())))
    elif sys.argv[1] in mcbShelf:
        pyperclip.copy(mcbShelf[sys.argv[1]])
        print('Successfully copied ' + sys.argv[1] + ' to the clipboard')
    else:
        print('Sorry to say but there is no ' + sys.argv[1] + ' in my records')

mcbShelf.close()
