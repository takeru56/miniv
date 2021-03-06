module token

// ExpectToken
struct ET {
	kind TokenKind
	val  int
	str  string
}

fn assert_token(expected ET, tk Token) {
	assert expected.kind == tk.kind
	if expected.kind == .num {
		assert expected.val == tk.val
	} else {
		assert expected.str == tk.str
	}
}

fn exec_test(input []string, expecting [][]ET) {
	for idx, s in input {
		mut tk := tokenize(s)
		mut i := 0
		for tk.kind != .eof {
			expected := expecting[idx][i++]
			assert_token(expected, tk)
			tk = tk.next
		}
	}
}

fn test_calc_tokenize() {
	input := [
		' 11   ',
		' 1 + 1 ',
		'1-1',
		'1000+100000-1',
		' 1000  + 100000 - 1  ',
		'(1+1) * 3',
		'3==3',
		'5>=3',
		'a',
		'b := 1',
		'c := 3 c',
		'hoge := 1',
		'a:=1 a=a+2 a',
		'tes_1 := 3'
		'return 1',
		'return 3+2',
		'returnd := 1',
		'ifs := 1',
		'elseval := 1'
	]
	expecting := [
		[
			ET{.num, 11, ''},
			ET{.eof}
		],
		[
			ET{.num, 1, ''},
			ET{.reserved, 0, '+'},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.num, 1, ''},
			ET{.reserved, 0, '-'},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.num, 1000, ''},
			ET{.reserved, 0, '+'},
			ET{.num, 100000, ''},
			ET{.reserved, 0, '-'},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.num, 1000, ''},
			ET{.reserved, 0, '+'},
			ET{.num, 100000, ''},
			ET{.reserved, 0, '-'},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.reserved, 0, '('},
			ET{.num, 1, ''},
			ET{.reserved, 0, '+'},
			ET{.num, 1, ''},
			ET{.reserved, 0, ')'},
			ET{.reserved, 0, '*'},
			ET{.num, 3, ''},
			ET{.eof}
		],
		[
			ET{.num, 3, ''},
			ET{.reserved, 0, '=='},
			ET{.num, 3, ''},
			ET{.eof}
		],
		[
			ET{.num, 5, ''},
			ET{.reserved, 0, '>='},
			ET{.num, 3, ''},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'a'},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'b'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'c'},
			ET{.reserved, 0, ':='},
			ET{.num, 3, ''},
			ET{.ident, 0, 'c'},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'hoge'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, '='},
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, '+'},
			ET{.num, 2, ''},
			ET{.ident, 0, 'a'},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'tes_1'},
			ET{.reserved, 0, ':='},
			ET{.num, 3, ''},
			ET{.eof, 0, ''},
		],
		[
			ET{.reserved, 0, 'return'},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.reserved, 0, 'return'},
			ET{.num, 3, ''},
			ET{.reserved, 0, '+'},
			ET{.num, 2, ''},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'returnd'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'ifs'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'elseval'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.eof}
		]
	]
	exec_test(input, expecting)
}

fn test_if_tokenize() {
	inputs := [
		'if 1+1 return 3',
		'if 1+1 return 2 else return 3'
	]
	expecting := [
		[
			ET{.reserved, 0, 'if'},
			ET{.num, 1, ''},
			ET{.reserved, 0, '+'},
			ET{.num, 1, ''},
			ET{.reserved, 0, 'return'},
			ET{.num, 3, ''},
			ET{.eof}
		],
		[
			ET{.reserved, 0, 'if'},
			ET{.num, 1, ''},
			ET{.reserved, 0, '+'},
			ET{.num, 1, ''},
			ET{.reserved, 0, 'return'},
			ET{.num, 2, ''},
			ET{.reserved, 0, 'else'},
			ET{.reserved, 0, 'return'},
			ET{.num, 3, ''},
			ET{.eof}
		]
	]
	exec_test(inputs, expecting)
}

fn test_for_tokenize() {
	inputs := [
		'a:=1 for a<10 a=a+1 return a'
	]
	expecting := [
		[
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.reserved, 0, 'for'},
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, '<'},
			ET{.num, 10, ''},
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, '='},
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, '+'},
			ET{.num, 1, ''},
			ET{.reserved, 0, 'return'},
			ET{.ident, 0, 'a'},
			ET{.eof}
		]
	]
	exec_test(inputs, expecting)
}

fn test_block_tokenize() {
	inputs := [
		'if 1 {a:=1 a=3}'
	]
	expecting := [
		[
			ET{.reserved, 0, 'if'},
			ET{.num, 1, ''},
			ET{.reserved, 0, '{'},
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, ':='},
			ET{.num, 1, ''},
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, '='},
			ET{.num, 3, ''},
			ET{.reserved, 0, '}'}
			ET{.eof}
		]
	]
	exec_test(inputs, expecting)
}

fn test_fn_tokenize() {
	inputs := [
		'func1()',
		'func2()',
		'fn func3(x int) int { return 2 }'
	]
	expecting := [
		[
			ET{.ident, 0, 'func1'},
			ET{.reserved, 0, '('},
			ET{.reserved, 0, ')'},
			ET{.eof}
		],
		[
			ET{.ident, 0, 'func2'},
			ET{.reserved, 0, '('},
			ET{.reserved, 0, ')'},
			ET{.eof}
		],
		[
			ET{.reserved, 0, 'fn'},
			ET{.ident, 0, 'func3'},
			ET{.reserved, 0, '('},
			ET{.ident, 0, 'x'},
			ET{.reserved, 0, 'int'},
			ET{.reserved, 0, ')'},
			ET{.reserved, 0, 'int'},
			ET{.reserved, 0, '{'},
			ET{.reserved, 0, 'return'},
			ET{.num, 2, ''},
			ET{.reserved, 0, '}'},
			ET{.eof}
		]
	]
	exec_test(inputs, expecting)
}

fn test_array_tokenize() {
	inputs := [
		'a := [1,2,3,4]'
	]
	expecting := [
		[
			ET{.ident, 0, 'a'},
			ET{.reserved, 0, ':='},
			ET{.reserved, 0, '['},
			ET{.num, 1, ''},
			ET{.reserved, 0, ','},
			ET{.num, 2, ''},
			ET{.reserved, 0, ','},
			ET{.num, 3, ''},
			ET{.reserved, 0, ','},
			ET{.num, 4, ''},
			ET{.reserved, 0, ']'},
			ET{.eof}
		]
	]
	exec_test(inputs, expecting)
}

fn test_string_tokenize() {
	inputs := [
		's := \'hello\''
	]
	expecting := [
		[
			ET{.ident, 0, 's'},
			ET{.reserved, 0, ':='},
			ET{.reserved, 0, '\''},
			ET{.text, 0, 'hello'},
			ET{.reserved, 0, '\''},
			ET{.eof}
		]
	]
	exec_test(inputs, expecting)
}
