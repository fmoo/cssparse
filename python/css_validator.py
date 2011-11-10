from text.cssparser.CSSParser import CSSParser
from text.cssparser.CSSLexer import CSSLexer
import antlr3
from argparse import ArgumentParser


def main():
    ap = ArgumentParser()
    ap.add_argument('input_files', nargs='+')

    ns = ap.parse_args()
    for file in ns.input_files:
        f = antlr3.FileStream(file)
        lexer = CSSLexer(f)
        tokenStream = antlr3.CommonTokenStream(lexer)
        parser = CSSParser(tokenStream)
        sheet = parser.styleSheet()
        print sheet.tree.toStringTree()
        print dir(sheet.tree)



if __name__ == '__main__':
    main()
