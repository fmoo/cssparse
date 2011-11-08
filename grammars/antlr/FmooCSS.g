grammar CSS;

/**
 * Only parse empty rules for now
 * TODO- updates from http://www.w3.org/TR/css3-syntax/#style
 */
styleSheet
  : ( CDO | CDC | WS | statement )*
  ;

statement
  : ruleset
  //| at_rule
  ;

ruleset
  : selectors_group WS* LBRACE
      // TODO - put declarations here
      WS* declaration? (SEMI WS* declaration?)*
    RBRACE
  ;

declaration
  : property COLON WS* values;

property
  : IDENT WS*
  ;

values
  : value (WS+ value)?
  ;

value
  : IDENT
  | NUMBER
  | PERCENTAGE
  | DIMENSION
  | STRING
  | URL
  | HASH IDENT
  ;

/**
 * Parse rules taken from http://www.w3.org/TR/selectors/#grammar
 * with some minor tweaks
 */
selectors_group
  : selector ( COMMA WS* selector )*
  ;

selector
  : simple_selector_sequence ( combinator
                               simple_selector_sequence )*
  ;

combinator
  /* combinators can be surrounded by whitespace */
  : PLUS WS* | GREATER WS* | TILDE WS* | WS+
  ;

simple_selector_sequence
  : ( type_selector | universal )
    ( HASH IDENT | cssclass | attrib | pseudo | negation )*
  | ( HASH IDENT | cssclass | attrib | pseudo | negation )+
  ;

type_selector
  : namespace_prefix? element_name
  ;

namespace_prefix
  : ( IDENT | STAR )? PIPE
  ;

element_name
  : IDENT
  ;

universal
  : namespace_prefix? STAR
  ;

cssclass
  : DOT IDENT
  ;

attrib
  : LBRACKET WS* namespace_prefix? IDENT WS*
        ( ( PREFIXMATCH |
            SUFFIXMATCH |
            SUBSTRINGMATCH |
            EQUALS |
            INCLUDES |
            DASHMATCH ) WS* ( IDENT | STRING ) WS*
          )? RBRACKET
  ;

pseudo
  /* '::' starts a pseudo-element, ':' a pseudo-class */
  /* Exceptions: :first-line, :first-letter, :before and :after. */
  /* Note that pseudo-elements are restricted to one per selector and */
  /* occur only in the last simple_selector_sequence. */
  : COLON COLON? ( IDENT | functional_pseudo )
  ;

functional_pseudo
  : IDENT LPAREN WS* expression RPAREN
  ;

expression
  /* In CSS3, the expressions are identifiers, strings, */
  /* or of the form "an+b" */
  : ( ( PLUS | MINUS | DIMENSION | NUMBER |
        PERCENTAGE | STRING | IDENT )
      WS* )+
  ;

negation
  : COLON 'not' LPAREN WS* negation_arg WS* RPAREN
  ;

negation_arg
  : type_selector | universal | HASH IDENT
  | cssclass | attrib | pseudo
  ;


/**
 * Lexer Fragments
 */
fragment
H
  :	'0'..'9'
  |	'a'..'f'
  |	'A'..'F'
  ;

fragment
ALPHA
  :	'a'..'z'
  |	'A'..'Z'
  ;

fragment
DIGIT
  :	'0'..'9'
  ;

fragment
NONASCII
  :	'\u0070'..'\ufffe'
  ;

fragment
NMSTART
  :	ALPHA
  |	'_'
  ;

fragment
NMCHAR
  :	NMSTART
  |	'0'..'9'
  |	'-'
  // |	NONASCII
  // |	ESCAPE
  ;

fragment
URLCHARS
  :	ALPHA
  |	DIGIT
  |	'/'
  |	'.'
  |	':'
  |	'-'
  |	'_'
  |	'%'
  ;

fragment
NL
  :	('\r'? '\n')=> '\r'? '\n'
  |	'\r'
  ;

/**
 * Lexer
 */
IDENT
  :	'-'? NMSTART NMCHAR*
  ;

HASH
  :	'#'
  ;

IMPORTANT
  :	'!important'
  ;

COMMENT
  :	'/*' (options {greedy=false;} : .)* '*/' {$channel=HIDDEN;}
    ;

LBRACE
  :	'{'
  ;

RBRACE
  :	'}'
  ;

LBRACKET
  :	'['
  ;

RBRACKET
  :	']'
  ;

LPAREN
  :	'('
  ;

RPAREN
  :	')'
  ;

INCLUDES
  : '~='
  ;

DASHMATCH
  : '|='
  ;

PREFIXMATCH
  :	'^='
  ;

SUFFIXMATCH
  :	'$='
  ;

SUBSTRINGMATCH
  :	'*='
  ;

EQUALS
  :	'='
  ;

SEMI
  :	';'
  ;

COLON
  :	':'
  ;

STAR
  :	'*'
  ;

PIPE
  : '|'
  ;

SLASHNINE
  :	'\\9'
  ;

DOT
  :   '.'
  ;

COMMA
  :	','
  ;

WS
  :	(	'\t'
  	|	' '
  	|	NL
  	)+
  ;

PLUS
  :	'+'
  ;

MINUS
  :	'-'
  ;

GREATER
  : '>'
  ;

TILDE
  : '~'
  ;

ATKEYWORD
  : '@' IDENT
  ;

NUMBER
  :	DIGIT+ ('.' DIGIT+)?
  |	'.' DIGIT+
  ;

DIMENSION
  :	NUMBER IDENT;

PERCENTAGE
  :	NUMBER '%'
  ;

CDO
  : '<!--'
  ;

CDC
  : '-->'
  ;

STRING
  :	'"' ( ~'"' )* '"'
  |   '\'' ( ~'\'' )* '\''
  ;

URL
  :	'url(' (STRING | URLCHARS+) ')'
  ;