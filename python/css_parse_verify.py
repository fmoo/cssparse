#!/usr/bin/env python
try:
    from text.cssparser.CSSParser import CSSParser
    from text.cssparser.CSSLexer import CSSLexer
except ImportError:
    from CSSParser import CSSParser
    from CSSLexer import CSSLexer
import antlr3
from argparse import ArgumentParser
import json
import sys
import logging
import traceback


class ErrorCapturingCSSParser(CSSParser):
    def __init__(self, *args, **kwargs):
        self.errors = []
        self.emit_errors = kwargs.pop('emit_errors', True)
        super(ErrorCapturingCSSParser, self).__init__(*args, **kwargs)

    def reportError(self, e):
        if not self._state.errorRecovery:
            self.errors.append(self.makeErrorDict(e))

        super(ErrorCapturingCSSParser, self).reportError(e)

    def emitErrorMessage(self, msg):
        if self.emit_errors:
            super(ErrorCapturingCSSParser, self).emitErrorMessage(msg)

    def makeErrorDict(self, e):
        return {
          'line': e.line,
          'col': e.charPositionInLine,
          'msg': self.getErrorMessage(e, self.tokenNames)
        }


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
    json_result = {}
    for file in ns.input_files:
        logging.getLogger('').debug("Processing %s", file)
        try:
            f = antlr3.FileStream(file)
            lexer = CSSLexer(f)
            tokenStream = antlr3.CommonTokenStream(lexer)
            parser = ErrorCapturingCSSParser(tokenStream,
                                             emit_errors=(not ns.json))
            parser.styleSheet()
            n_errors += parser.getNumberOfSyntaxErrors()

            if ns.json:
                json_result.setdefault(file, []).extend(parser.errors)
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
