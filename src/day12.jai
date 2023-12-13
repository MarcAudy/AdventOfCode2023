#import "Basic";
#import "Hash";
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
	print("Day12 Part2 Sample : %\n", run_main("sample"));
	print("Day12 Part2        : %\n", run_main());
}

PatternInfo :: struct {
	unknown_count: int;
	damage_count: int;
	total_damaged: int;
	group_count: int;
	group_index: int;
	damage_groups: []int;
}

SeenSituation :: struct {
	pattern: string;
	group_count: int;
	group_index: int;
}
operator == :: (a: SeenSituation, b: SeenSituation) -> bool {
	return 
		a.group_count == b.group_count && 
		a.group_index == b.group_index && 
		a.pattern == b.pattern;	
}
compare_situations :: (a: SeenSituation, b: SeenSituation) -> bool {
	return a == b;
}
situation_hash :: (using ss: SeenSituation) -> u32 {
	SituationHash :: struct {
		pattern_hash: int;
		group_count: int;
		group_index: int;
	}
	return sdbm_hash(*SituationHash.{get_hash(pattern),group_count,group_index},size_of(SituationHash));
}

recursive_check_pattern :: (pattern: string, pattern_info: PatternInfo) -> int {
	if (pattern_info.damage_count + pattern_info.unknown_count) < pattern_info.total_damaged {
		return 0;
	}
	if pattern.count == 0 {
		assert(pattern_info.unknown_count == 0);
		group_index := pattern_info.group_index;
		if pattern_info.group_count > 0 {
			if pattern_info.group_count != pattern_info.damage_groups[pattern_info.group_index] {
				return 0;
			}
			group_index += 1;
		}

		return ifx group_index == pattern_info.damage_groups.count 1 else 0;
	}
	seen_result, success := table_find(*seen_situations,.{pattern,pattern_info.group_count,pattern_info.group_index});
	if success {
		return seen_result;
	}

	if pattern[0] != #char "?" {
		new_pattern_info := pattern_info;
		if pattern[0] == #char "." {
			if pattern_info.group_count > 0 {
				if pattern_info.group_count != pattern_info.damage_groups[pattern_info.group_index] {
					return 0;
				}
				new_pattern_info.group_count = 0;
				new_pattern_info.group_index += 1;
			}
		}
		else {
			if pattern_info.group_count == 0 && pattern_info.group_index == pattern_info.damage_groups.count {
				return 0;
			}
			new_pattern_info.group_count += 1;
			if new_pattern_info.group_count > pattern_info.damage_groups[pattern_info.group_index] {
				return 0;
			}
		}
		return recursive_check_pattern(slice(pattern,1,pattern.count-1), new_pattern_info);
	}

	result := 0;
	if pattern_info.group_count == 0 || pattern_info.group_count == pattern_info.damage_groups[pattern_info.group_index] {
		new_pattern_info := pattern_info;
		new_pattern_info.unknown_count -= 1;
		if pattern_info.group_count > 0 {
			new_pattern_info.group_count = 0;
			new_pattern_info.group_index += 1;
		}
		result += recursive_check_pattern(slice(pattern,1,pattern.count-1), new_pattern_info);
	}

	if (pattern_info.damage_count < pattern_info.total_damaged &&
		(pattern_info.group_count > 0 || pattern_info.group_index < pattern_info.damage_groups.count)) {
		new_pattern_info := pattern_info;
		new_pattern_info.group_count += 1;
		if new_pattern_info.group_count <= pattern_info.damage_groups[pattern_info.group_index] {
			new_pattern_info.unknown_count -= 1;
			new_pattern_info.damage_count += 1;
			result += recursive_check_pattern(slice(pattern,1,pattern.count-1), new_pattern_info);
		}
	}

	table_add(*seen_situations,.{pattern,pattern_info.group_count,pattern_info.group_index},result);
	return result;
}

sum: int;
seen_situations: Table(SeenSituation, int, situation_hash, compare_situations);

run_main :: (suffix := "") -> int {
	
	sum = 0;
	process_line :: (line: string) {
		
		split_line :: (line: string) -> string, [..]int, int {
			s1 := split(line," ");
			groups: [..]int;
			total_damaged := 0;
			for split(s1[1],",") {
				num, success := string_to_int(it);
				if (success) {
					array_add(*groups, num);
					total_damaged += num;
				}
			}
			return s1[0], groups, total_damaged;
		}

		pattern, groups, total_damaged := split_line(line);

		if part == .PART2 {
			total_damaged *= 5;
			group_count := groups.count;
			for 1..4 {
				for 0..group_count-1 {
					array_add(*groups,groups[it]);	
				}
			}
			pattern = sprint("%1?%2?%3?%4?%5",pattern,pattern,pattern,pattern,pattern);
		}
		
		pattern_info: PatternInfo;
		pattern_info.damage_groups = groups;
		pattern_info.total_damaged = total_damaged;

		for cast([]u8) pattern {
			if it == #char "?" {
				pattern_info.unknown_count += 1;
			}
			else if it == #char "#" {
				pattern_info.damage_count += 1;
			}
		}

		table_reset(*seen_situations);
		sum += recursive_check_pattern(pattern, pattern_info);
	}
	process_file("day12", process_line, suffix);

	return sum;
}