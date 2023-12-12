#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

part: Parts;
run :: () {
	part = .PART1;
	print("Day12 Part1 Sample : %\n", run_main("sample"));
	print("Day12 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day11 Part2 Sample : %\n", run_main("sample"));
	//print("Day11 Part2        : %\n", run_main());
}

is_valid_pattern :: (pattern: string, groups: []int) -> bool {
	//print("%\n",pattern);
	group_index := 0;
	group_count := 0;
	for cast([]u8) pattern {
		if it == #char "." {
			if group_count > 0 {
				if group_count != groups[group_index] {
					return false;
				}
				group_count = 0;
				group_index += 1;
			}
		}
		else {
			if group_count == 0 && group_index == groups.count {
				return false;
			}
			group_count += 1;
			if group_count > groups[group_index] {
				return false;
			}
		}
	}
	if group_count > 0 {
		if group_count != groups[group_index] {
			return false;
		}
		group_index += 1;
	}

	return group_index == groups.count;
}

recursive_check_pattern :: (pattern: string, unknown_indices: []int, groups: []int) -> int {
	if unknown_indices.count == 0 {
		return ifx is_valid_pattern(pattern, groups) 1 else 0;
	}
	pattern[unknown_indices[0]] = #char ".";
	result := recursive_check_pattern(pattern, array_view(unknown_indices,1), groups);
	pattern[unknown_indices[0]] = #char "#";
	result += recursive_check_pattern(pattern, array_view(unknown_indices,1), groups);
	return result;
}

sum: int;
run_main :: (suffix := "") -> int {
	
	sum = 0;

	process_line :: (line: string) {
		
		split_line :: (line: string) -> string, [..]int {
			s1 := split(line," ");
			groups: [..]int;
			for split(s1[1],",") {
				num, success := string_to_int(it);
				if (success) {
					array_add(*groups, num);
				}
			}
			return s1[0], groups;
		}

		partial_pattern, groups := split_line(line);
		
		unknown_indices: [..]int;
		for cast([]u8) partial_pattern {
			if it == #char "?" {
				array_add(*unknown_indices, it_index);
			}
		}

		matches := recursive_check_pattern(partial_pattern, unknown_indices, groups);

		sum += matches;
	}
	process_file("day12", process_line, suffix);

	return sum;
}