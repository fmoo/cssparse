import java.io.*;
import org.antlr.runtime.*;


public class TestCSSLexer {

    public static void main(String args[]) throws Exception {
        int code = 0;
        for (String path : args) {
            CSS21Lexer lex = new CSS21Lexer(new ANTLRFileStream(path, "UTF8"));
            CommonTokenStream tokens = new CommonTokenStream(lex);
            Token token;
            do {
                token = lex.nextToken();
                System.out.println("Token: <" + token + ">");
            } while (token.getType() != Token.EOF);
        }
        System.exit(code);
    }
}
