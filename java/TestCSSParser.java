import java.io.*;
import org.antlr.runtime.*;


public class TestCSSParser {

    public static void main(String args[]) throws Exception {
        int code = 0;
        for (String path : args) {
            CSS21Lexer lex = new CSS21Lexer(new ANTLRFileStream(path, "UTF8"));
            CommonTokenStream tokens = new CommonTokenStream(lex);

            CSS21Parser g = new CSS21Parser(tokens);
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
