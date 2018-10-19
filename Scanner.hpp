#ifndef __SCANNER_HPP__
#define __SCANNER_HPP__

#include <iostream>
#include <fstream>
using namespace std;

#undef yyFlexLexer
#include <FlexLexer.h>

#include "Parser.hpp"

// 前方参照 (Scanner <-> ParseDriver の相互参照解決）
class Scanner;
#include "ParseDriver.hpp"

// yylex()の関数定義冒頭の挿げ替え
// ソース上に現れる実際の宣言はファイル末尾。実装はScanner.cpp内に生成されたYY_DECLで，YY_DECLはScanner.cpp内で↓の定義をincludeした時に定義され，本来のYY_DECLの定義は#ifndef YY_DECLによってスルーされる
#undef YY_DECL
#define YY_DECL \
yy::Parser::token_type \
	Scanner::scan(yy::Parser::semantic_type* yylval, \
				  yy::Parser::location_type* yylloc, \
				  ParseDriver& driver)

class Scanner : public yyFlexLexer {
public:
	Scanner(ifstream &ifs) : yyFlexLexer(&ifs) { }
	yy::Parser::token_type scan(yy::Parser::semantic_type* value,
								yy::Parser::location_type* location,
								ParseDriver& driver);
};

#endif




