import java.io.*;
import org.antlr.runtime.*;


public class TestCSSParser {

    public static void main(String args[]) throws Exception {
        int code = 0;
        for (String path : args) {
            CSSLexer lex = new CSSLexer(new ANTLRFileStream(path, "UTF8"));
            CommonTokenStream tokens = new CommonTokenStream(lex);

            CSSParser g = new CSSParser(tokens);
            try {
                g.styleSheet();
            } catch (RecognitionException e) {
                code = 1;
                e.printStackTrace();
            }
        }
        System.exit(code);
    }
}
