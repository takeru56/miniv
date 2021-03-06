module parser

struct Table {
pub mut:
	lvar map[string]Lvar
	latest_lvar &Lvar
}

// TODO: refactor local variable management.
// these are little complex.
struct Lvar {
pub:
	name   string
	offset int
	is_array bool
pub mut:
	len int = 1
	typ TypeKind
}

enum TypeKind {
	typ_int
	typ_array
	typ_struct
}

fn type_kind(s string) TypeKind {
	match s {
		'int' { return .typ_int }
		else {}
	}
}

fn type_str(tk TypeKind) string {
	match tk {
		.typ_int {return 'int'}
		else {}
	}
}

fn (t &Table) next_offset() int {
	return t.latest_lvar.offset + (8 * t.latest_lvar.len)
}

fn (t &Table) enter_lvar(name string) &Lvar {
	lvar := Lvar{name: name, offset: t.next_offset()}
	t.lvar[name] = lvar
	// TODO: little complex. not to use pointer
	t.latest_lvar = &t.lvar[name]
	return &t.lvar[name]
}

fn (t &Table) search_lvar(name string) bool {
	return name in t.lvar
}

fn (t &Table) get_offset(name string) int {
	return t.lvar[name].offset
}
