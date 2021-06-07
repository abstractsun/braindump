#!/bin/bash
# braindump
# (c) abstractsun
# License: GPL version 3 or, at your option, any later version

grep -irnE -B1 "\{$1\}" ideas notes | less
