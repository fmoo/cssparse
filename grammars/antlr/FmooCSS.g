grammar CSS;

/**
 * Based loosely on http://www.w3.org/TR/css3-syntax/#style
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
      WS* declaration? (SEMI WS* declaration?)*
    RBRACE
  ;

declaration
  : ie_prefix_hack?
    property COLON WS* values
    WS* IMPORTANT?
    ie_suffix_hack?
  ;

ie_prefix_hack
  : STAR WS*
  | DOT
  ;

ie_suffix_hack
  : SLASHNINE
  ;

property
  : IDENT WS*
  ;

values
  : value
    ( (WS+ value)
    | (WS* COMMA WS* value)
    | SLASH value
    )*
  ;

name_values
  : IDENT WS* EQUALS WS* value
    ( WS* COMMA WS* IDENT WS* EQUALS WS* value )*
  ;

value
  : (PLUS|MINUS)? NUMBER
  | (PLUS|MINUS)? PERCENTAGE
  | (PLUS|MINUS)? DIMENSION
  | IDENT
  | STRING
  | URL
  | HASH
  | MS_EXPRESSION
  | value_function;

value_function
  : function_name LPAREN
    ( WS*
    | WS*
      ( name_values
      | values
      )
      WS*
    )
    RPAREN
  ;

function_name
  : IDENT ((COLON|DOT) IDENT)*
  ;

/**
 * Parse rules taken from http://www.w3.org/TR/selectors/#grammar
 * with some minor tweaks
 */
selectors_group
  : selector
    ( WS* COMMA WS* selector )*
  ;

selector
  : simple_selector_sequence ( combinator
                               simple_selector_sequence )*
  ;

combinator
  /* combinators can be surrounded by whitespace */
  : WS* PLUS WS*
  | WS* GREATER WS*
  | WS* TILDE WS*
  | WS+
  ;

simple_selector_sequence
  : ( type_selector | universal )
    ( HASH | cssclass | attrib | pseudo | negation )*
  | ( HASH | cssclass | attrib | pseudo | negation )+
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
  : type_selector | universal | HASH
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
  |	';'
  |	','
  |	'%'
  ;

fragment
NL
  :	('\r'? '\n')=> '\r'? '\n'
  |	'\r'
  ;

fragment
NESTED_PARENS
  : '('
      ( options {greedy=false;}
      : ( NESTED_PARENS
        | .)
      )*
    ')'
  ;

/**
 * Lexer
 */
IDENT
  :	'-'? NMSTART NMCHAR*
  ;

HASH
  :	'#' NMCHAR+
  ;

IMPORTANT
  :	'!' WS* 'important'
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

SLASH
  : '/'
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
  : DIGIT+
  | DIGIT* DOT DIGIT+
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

MS_EXPRESSION
  : 'expression' NESTED_PARENS
  ;
