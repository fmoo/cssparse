grammar CSS;

/**
 * Parser
 */

styleSheet
	:	IDENT+ EOF
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
	:   '~='
    ;

DASHMATCH
    :   '|='
    ;

STARTSWITH
	:	'^='
	;

ENDSWITH
	:	'$='
	;

CONTAINS
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

SLASHNINE
	:	'\\9'
	;

DOT
	:   '.'
	;

COMMA
	:	','
	;
NL
	:	('\r'? '\n')=> '\r'? '\n'
	|	'\r'

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

NUMBER
	:	DIGIT+ ('.' DIGIT+)?
	|	'.' DIGIT+
	;

DIMENSION
	:	NUMBER IDENT;

PERCENT
	:	NUMBER '%'
	;

STRING
	:	'"' ( ~'"' )* '"'
	|   '\'' ( ~'\'' )* '\''
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

URL
	:	'url(' (STRING | URLCHARS+) ')'
	;
