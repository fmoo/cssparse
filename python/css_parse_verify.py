#!/usr/bin/env python
from argparse import ArgumentParser
import json
import sys
import logging
import traceback
from collections import defaultdict
import antlr3
try:
    from text.cssparser.parse_utils import *
except ImportError:
    from parse_utils import *


def main():
    ap = ArgumentParser()
    ap.add_argument('input_files', nargs='+')
    ap.add_argument('--json', action='store_true',
                    help="Output errors as json instead of to stderr")
    ap.add_argument('--level', default='INFO',
                    help="Log Level [%(default)s]")

    ns = ap.parse_args()

    # Init Logging
    logging.basicConfig()
    logging.getLogger('').setLevel(getattr(logging, ns.level.upper()))

    n_errors = 0
    json_result = defaultdict(list)
    for file in ns.input_files:
        logging.getLogger('').debug("Processing %s", file)
        try:
            f = antlr3.FileStream(file)
            lexer = ErrorCapturingCSSLexer(f,
                                           emit_errors=(not ns.json))
            tokenStream = antlr3.CommonTokenStream(lexer)
            parser = ErrorCapturingCSSParser(tokenStream,
                                             emit_errors=(not ns.json))
            parser.styleSheet()
            n_errors += parser.getNumberOfSyntaxErrors()

            if ns.json:
                json_result[file].extend(lexer.errors)
                json_result[file].extend(parser.errors)

        except Exception as e:
            if ns.json:
                msg = traceback.format_exc()
                json_result.setdefault(file, []).append({'msg': msg})
            else:
                traceback.print_exc(file=sys.stderr)

    if ns.json:
        print json.dumps(json_result)

    if n_errors > 0:
        sys.exit(1)

if __name__ == '__main__':
    main()
