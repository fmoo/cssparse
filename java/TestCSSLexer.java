import java.io.*;
import java.lang.reflect.Field;
import org.antlr.runtime.*;


public class TestCSSLexer {

    public static String getTokenName(int n) {
        for (Field f : CSSLexer.class.getDeclaredFields()) {
            try {
                if (f.getInt(null) == n) {
                    return f.getName();
                }
            } catch (IllegalAccessException ex) { }
        }
        return "Unknown";
    }

    public static void main(String args[]) throws Exception {
        int code = 0;
        for (String path : args) {
            CSSLexer lex = new CSSLexer(new ANTLRFileStream(path, "UTF8"));
            CommonTokenStream tokens = new CommonTokenStream(lex);
            Token token;
            do {
                token = lex.nextToken();
                System.out.println(
                    "<" + getTokenName(token.getType()) +
                    ": " + token + ">");
            } while (token.getType() != Token.EOF);
        }
        System.exit(code);
    }
}
