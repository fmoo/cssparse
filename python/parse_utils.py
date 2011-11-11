import antlr3

try:
    from text.cssparser.CSSParser import CSSParser
    from text.cssparser.CSSLexer import CSSLexer
except ImportError:
    from CSSParser import CSSParser
    from CSSLexer import CSSLexer

class ErrorCapturingRecognizer(antlr3.BaseRecognizer):
    def __init__(self, *args, **kwargs):
        self.errors = []
        self.emit_errors = kwargs.pop('emit_errors', True)
        super(ErrorCapturingRecognizer, self).__init__(*args, **kwargs)

    def emitErrorMessage(self, msg):
        if self.emit_errors:
            super(ErrorCapturingCSSParser, self).emitErrorMessage(msg)

    def makeErrorDict(self, e):
        return {
          'line': e.line,
          'col': e.charPositionInLine,
          'msg': self.getErrorMessage(e, self.tokenNames)
        }

class ErrorCapturingCSSLexer(ErrorCapturingRecognizer, CSSLexer):
    pass        

class ErrorCapturingCSSParser(ErrorCapturingRecognizer, CSSParser):
    def reportError(self, e):
        if not self._state.errorRecovery:
            self.errors.append(self.makeErrorDict(e))

        super(ErrorCapturingCSSParser, self).reportError(e)
