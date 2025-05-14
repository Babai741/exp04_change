grammar MiniC;

// 词法规则名总是以大写字母开头

// 语法规则名总是以小写字母开头

// 每个非终结符尽量多包含闭包、正闭包或可选符等的EBNF范式描述

// 若非终结符由多个产生式组成，则建议在每个产生式的尾部追加# 名称来区分，详细可查看非终结符statement的描述

// 语法规则描述：EBNF范式

// 源文件编译单元定义
compileUnit: (funcDef | varDecl)* EOF;

// 函数定义，目前不支持形参，也不支持返回void类型等
funcDef: T_INT T_ID T_L_PAREN T_R_PAREN block;

// 语句块看用作函数体，这里允许多个语句，并且不含任何语句
block: T_L_BRACE blockItemList? T_R_BRACE;

// 每个ItemList可包含至少一个Item
blockItemList: blockItem+;

// 每个Item可以是一个语句，或者变量声明语句
blockItem: statement | varDecl;

// 变量声明，目前不支持变量含有初值
varDecl: basicType varDef (T_COMMA varDef)* T_SEMICOLON;

// 基本类型
basicType: T_INT;

// 变量定义
varDef: T_ID;

// 目前语句支持return和赋值语句
statement:
	T_RETURN expr T_SEMICOLON			# returnStatement
	| lVal T_ASSIGN expr T_SEMICOLON	# assignStatement
	| block								# blockStatement
	| expr? T_SEMICOLON					# expressionStatement;

// 表达式文法 expr : AddExp 表达式目前只支持加法与减法运算
expr: addExp;

// 修改后的加减表达式规则，支持乘法、除法和求余运算
addExp: mulExp (addOp mulExp)*;

// 新增乘除余表达式规则
mulExp: unaryExp (mulOp unaryExp)*;

// 新增乘、除、求余运算符
mulOp: T_MUL | T_DIV | T_MOD;

// 加减运算符
addOp: T_ADD | T_SUB;

// 修改后的unaryExp规则，支持负号运算（负数解析为无符号数和负号）
unaryExp: T_SUB primaryExp   # negativeUnaryExp  // 负号运算
        | primaryExp
        | T_ID T_L_PAREN realParamList? T_R_PAREN;

// 基本表达式：括号表达式、整数、左值表达式
primaryExp: T_L_PAREN expr T_R_PAREN | T_DIGIT | lVal;

// 实参列表
realParamList: expr (T_COMMA expr)*;

// 左值表达式
lVal: T_ID;

// 用正规式来进行词法规则的描述

T_L_PAREN: '(';
T_R_PAREN: ')';
T_SEMICOLON: ';';
T_L_BRACE: '{';
T_R_BRACE: '}';

T_ASSIGN: '=';
T_COMMA: ',';

T_ADD: '+';
T_SUB: '-';
T_MUL: '*';  // 新增乘号
T_DIV: '/';  // 新增除号
T_MOD: '%';  // 新增求余符号

// 要注意关键字同样也属于T_ID，因此必须放在T_ID的前面，否则会识别成T_ID
T_RETURN: 'return';
T_INT: 'int';
T_VOID: 'void';

T_ID: [a-zA-Z_][a-zA-Z0-9_]*;

// 修改后的T_DIGIT，支持八进制与十六进制
T_DIGIT: '0' [0-7]*                     // 八进制数字
       | '0' [xX] [0-9a-fA-F]+          // 十六进制数字
       | [1-9][0-9]*;                   // 十进制数字

/* 空白符丢弃 */
WS: [ \r\n\t]+ -> skip;
