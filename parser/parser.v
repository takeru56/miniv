module parser

import token

enum NodeKind {
	add
	sub
	mul
	div
	num
}

struct Node {
	pub mut:
	kind NodeKind
	val int
	lhs &Node
	rhs &Node
}

struct Parser {
	pub mut:
	token token.Token
}

pub fn new_parser(tk token.Token) &Parser {
	return &Parser{tk}
}

fn (p &Parser) parse() &Node {
  return p.expr()
}

fn new_node(kind NodeKind, lhs &Node, rhs &Node) &Node {
	return &Node{kind, 0, lhs, rhs}
}

fn new_node_num(val int) &Node {
	return &Node{.num, val, 0, 0}
}

fn (p &Parser) expr() &Node {
	node := p.mul()

	for {
		if p.token.consume('+') {
			node = new_node(.add, node, p.mul())
		} else if p.token.consume('-') {
			node = new_node(.sub, node, p.mul())
		} else {
			return node
		}
	}
}

fn (p &Parser) mul() &Node {
	node := p.primary()

	for {
		if p.token.consume('*') {
			node = new_node(.mul, node, p.primary())
		} else if p.token.consume('/'){
			node = new_node(.div, node, p.primary())
		} else {
			return node
		}
	}
}

fn (p &Parser) primary() &Node {
	if p.token.consume('(') {
		node := p.expr()
		p.token.expect(')')
		return node
	}
	return new_node_num(p.token.expect_number())
}
