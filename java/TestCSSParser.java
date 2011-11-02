import java.io.*;
import org.antlr.runtime.*;


public class TestCSSParser {

    public static void main(String args[]) throws Exception {
        int code = 0;
        for (String path : args) {
            css21Lexer lex = new css21Lexer(new ANTLRFileStream(path, "UTF8"));
            CommonTokenStream tokens = new CommonTokenStream(lex);

            css21Parser g = new css21Parser(tokens);
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
