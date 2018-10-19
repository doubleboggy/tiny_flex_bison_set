%skeleton "lalr1.cc"
%require "2.1a"

%defines
%define parser_class_name { Parser }
%code requires {
	class ParseDriver;
}
%debug
%error-verbose

%parse-param { ParseDriver& driver }	// the 1st param of Parser's constructor
%lex-param	 { PaersDriver& driver }	// the 3rd param of yylex()

%locations
%initial-action
{
	// refer "location.hh", "position.hh"
	@$.begin.filename = @$.end.filename = &driver.file;
};

%{
	// do nothing
%}

%union {
	int			 ival;
	std::string *sval;
};

%token			END 0		"end of file"
%token <sval>	IDENTIFIER	"identifier"
%token <ival>	NUMBER		"number"

%printer	{ debug_stream() << *$$; } "identifier"
%destructor	{ delete $$; } "identifier"
%printer	{ debug_stream() << $$; } "number"

%{
#include "ParseDriver.hpp"			// 忘れがち！！！！！！！！！！！！！！！！！！！！！！

// new yylex() function for Parser
// #define YY_DECL \なんちゃらかんちゃらと紛らわしい
yy::Parser::token_type
yylex(yy::Parser::semantic_type* yylval,
	  yy::Parser::location_type* yylloc,
	  ParseDriver& driver) {
	return driver.scanner->scan(yylval, yylloc, driver);
}

// bison's spec: it's our duty to implement error routine
// ParseDriver::error()もあり，紛らわしい。←は第1引数がyy::location&型。
// で結局それを呼んでる↓自動でキャストしてくれるのか？
void
yy::Parser::error(const yy::Parser::location_type& l,
				  const std::string& m) {
	driver.error(l, m);
}

%}

%%

stmts	: stmt
		| stmts stmt
;

stmt	: IDENTIFIER
		| NUMBER
;

%%





















