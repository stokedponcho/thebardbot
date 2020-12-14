#!/bin/python
""" Retrieves a random quote from a random author
    from https://en.wikiquote.org/wiki/
"""

from random import choice

from wikiquote import quotes

QUOTE_PROVIDER = lambda name: quotes(name) #pylint: disable=unnecessary-lambda
VIPS = [
        'Linus Torvalds',
        'Richard Stallman',
        'John D. Carmack',
        'Bill Gates',
        'Donald Knuth',
        'Steve Wozniak',
        'Edsger W. Dijkstra',
        'Alan Perlis',
        'Linus Torvalds',
        'Donald Trump'
]

def get():
    """ Returns a (quote, author) tuple
    """
    author = choice(VIPS)
    quote = choice(quotes(author))

    return (quote, author)
