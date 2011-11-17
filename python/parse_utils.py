#
# Copyright 2011 Facebook, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.

import antlr3

try:
    from text.cssparser.CSSParser import CSSParser
    from text.cssparser.CSSLexer import CSSLexer
except ImportError:
    from CSSParser import CSSParser
    from CSSLexer import CSSLexer

class ErrorCapturingRecognizer(antlr3.BaseRecognizer):
    token_lookup = None

    def __init__(self, *args, **kwargs):
        self.errors = []
        self.emit_errors = kwargs.pop('emit_errors', True)
        super(ErrorCapturingRecognizer, self).__init__(*args, **kwargs)

    def emitErrorMessage(self, msg):
        if self.emit_errors:
            super(ErrorCapturingRecognizer, self).emitErrorMessage(msg)

    def makeErrorDict(self, e):
        return {
          'line': e.line,
          'col': e.charPositionInLine,
          'msg': self.getErrorMessage(e, self.tokenNames)
        }

    @classmethod
    def token_to_name(cls, token):
        if cls.token_lookup is None:
            cls.token_lookup = {}
            for k in dir(cls):
                if k != k.upper():
                    continue
                v = getattr(cls, k)
                if not isinstance(v, (int, long)):
                    continue
                cls.token_lookup[v] = k

        return cls.token_lookup.get(token.getType(), 'UNKNOWN')

class ErrorCapturingCSSLexer(ErrorCapturingRecognizer, CSSLexer):
    pass

class ErrorCapturingCSSParser(ErrorCapturingRecognizer, CSSParser):
    def reportError(self, e):
        if not self._state.errorRecovery:
            self.errors.append(self.makeErrorDict(e))

        super(ErrorCapturingCSSParser, self).reportError(e)
