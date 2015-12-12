#!/usr/bin/env python
# -*- coding: utf-8 -*- 
from __future__ import print_function

"""
Pandoc filter to convert divs with class="theorem" to LaTeX
theorem environments in LaTeX output, and to numbered theorems
in HTML output.
"""

import sys
from pandocfilters import toJSONFilter, RawBlock, Div


theoremcount = 0

def theorems(key, value, format, meta):
    if key == 'Para':
        if value[0]['t'] == u'Strong':
            print(value[0], file=sys.stderr)
            if len(value[0]['c']) > 0:
                if value[0]['c'][0]['t'] == u'Str' and value[0]['c'][0]['c'] == u'Teoremă.':
                    return Div([u"mylabel", ['theorem'], []], value[1:])

if __name__ == "__main__":
    toJSONFilter(theorems)
