import antlr3
import unittest2
import os.path
from functools import partial


try:
    from text.cssparser.parse_utils import *
except ImportError:
    from parse_utils import *


def get_example_file_dirs():
    return [
      os.path.join(get_test_dir(), '..', 'example'),
      os.path.join(get_test_dir(), 'example'),
    ]


def get_test_dir():
    return os.path.dirname(__file__)


def iter_example_files():
    for dir in get_example_file_dirs():
        try:
            files = os.listdir(dir)
        except Exception:
            continue

        for file in os.listdir(dir):
            if file.lower().endswith('.css'):
                yield os.path.join(dir, file)


class TestCSSParser(unittest2.TestCase):
    pass


def make_test_function(file):
    def do_test_css_file(self):
        fs = antlr3.FileStream(file)
        lexer = ErrorCapturingCSSLexer(fs, emit_errors=False)
        ts = antlr3.CommonTokenStream(lexer)
        parser = ErrorCapturingCSSParser(ts, emit_errors=False)
        parser.styleSheet()
        self.assertEquals(len(lexer.errors), 0, lexer.errors)
        self.assertEquals(len(parser.errors), 0, parser.errors)

    return do_test_css_file


for i, file in enumerate(iter_example_files()):
    setattr(TestCSSParser, 'test_css_file_%d (%s)' % (i + 1, file),
            make_test_function(file))


if __name__ == '__main__':
    unittest2.main()
