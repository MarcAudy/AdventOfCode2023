#import "Basic";
#import "Hash";
#import "Hash_Table";
#import "Math";
#import "String";
#import "System";
#import "Text_File_Handler";

Parts :: enum u8 {
	PART1;
	PART2;
}

default_table_formatter :: (n: Any, v: Any) -> string {
	return tprint("%: %",n,v);
}

print_table :: (table: Table, separator := "\n", formatter := default_table_formatter) {
	print("%\n",sprint_table(table,separator,formatter));
}

sprint_table :: (table: Table, separator := "\n", formatter := default_table_formatter) -> string {
	result: string;
	for v, n: table {
		result = sprint("%1%2%3",result,formatter(n,v),separator);
	}
	return result;
}

table_intersection :: (a: Table, b: Table(a.Key_Type, a.Value_Type)) -> Table(a.Key_Type, a.Value_Type) {
	result: Table(a.Key_Type, a.Value_Type);
	for v, n: a {
		if table_contains(*b, n) {
			table_set(*result,n,v);
		}
	}
		
	return result;
}

Point :: struct {
	x: int;
	y: int;
}
operator + :: (a: Point, b: Point) -> Point {
	return Point.{a.x+b.x,a.y+b.y};
}
operator += :: (self: *Point, other: Point) {
	self.x += other.x;
	self.y += other.y;
}
operator == :: (a: Point, b: Point) -> bool {
	return a.x == b.x && a.y == b.y;
}
compare_points :: (a: Point, b: Point) -> bool {
	return a == b;
}
point_hash :: (p: Point) -> u32 {
	return sdbm_hash(*p, size_of(Point));
}
dist_between :: (p1: Point, p2: Point) -> int {
	return abs(p1.x-p2.x) + abs(p1.y-p2.y);
}

get_greatest_common_demoninator :: (a_in: int, b_in: int) -> int {
	a := a_in;
	b := b_in;
	while true {
		r := a % b;
		if r == 0 return b;
		a = b;
		b = r;
	}
	assert(false);
	return 0;
}

get_least_common_multiple :: (values: []int) -> int {
	first_num := values[0];
	for 1..values.count-1 {
		second_num := values[it];
		gcd := get_greatest_common_demoninator(first_num, second_num);
		lcm := (first_num * second_num) / gcd;
		first_num = lcm;
	}
	return first_num;
}

get_input_file_handler :: (day: string, suffix := "") -> Text_File_Handler
{
	handler: Text_File_Handler;
	handler.do_version_number = false;
	handler.comment_character = #char "~";
	handler.strip_comments_from_ends_of_lines = false;
	handler.auto_skip_blank_lines = false;

	found, exe_path, exe_name := split_from_right(get_path_of_running_executable(), #char "/");
    if !found {
        print("Error: Unable to find my own executable?!\n");
    }
	else {
		filename := ifx suffix tprint("%_%.txt",day,suffix) else tprint("%.txt",day);
		filepath := tprint("%/../input/%", exe_path, filename);
	
		start_file(*handler, day, filepath, false);
	}
	return *handler;
}

process_file :: (day: string, func: (string), suffix := "") {
    handler := get_input_file_handler(day, suffix);
    defer deinit(*handler);

	if handler.failed {
		return;
	}

	while (true) {
        line, found := consume_next_line(*handler);
        if !found break;   // consume_next_line returns false for 'found' when we are done.

		func(line);
	}	
}

map :: (array: [] $T, f: (T) -> $S) -> [..] S {
	results: [..] S;

	for array array_add(*results, f(it));

	return results;
}

find_in_string :: (str: string, to_find: string, reverse := false) -> int {

	if to_find.count == 0 {
		return -1;
	}
	if to_find.count > str.count {
		return -1;
	}

	search_str := str;
	search_str.count = to_find.count;

	if reverse {
		search_str.data += str.count-to_find.count;
		for < str.count-to_find.count..0 {
			if search_str == to_find {
				return it;
			}
			search_str.data -= 1;
		}
	}
	else {
		for 0..str.count-to_find.count {
			if search_str == to_find {
				return it;
			}
			search_str.data += 1;
		}
	}

	return -1;
}

run_tests :: () {
	assert(find_in_string("hello","hello") == 0);
	assert(find_in_string("hello","hello",true) == 0);
	assert(find_in_string("hello","h") == 0);
	assert(find_in_string("hello","h", true) == 0);
	assert(find_in_string("hello","o") == 4);
	assert(find_in_string("hello","o", true) == 4);
	assert(find_in_string("hello","he") == 0);
	assert(find_in_string("hello","he", true) == 0);
	assert(find_in_string("hello","no") == -1);
	assert(find_in_string("hello","no",true) == -1);
	assert(find_in_string("hihi","hi") == 0);
	assert(find_in_string("hihi","hi",true) == 2);
}