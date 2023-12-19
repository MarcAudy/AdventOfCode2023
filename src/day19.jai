#import "Basic";
#import "Hash";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

run :: () {
	sample_part1, sample_part2 := run_main("sample");
	part1, part2               := run_main();
	print("Day19 Part1 Sample: %\n", sample_part1);
	print("Day19 Part1       : %\n", part1);
	print("Day19 Part2 Sample: %\n", sample_part2);
	print("Day19 Part2       : %\n", part2);
}

RatingType :: enum {
	x :: 0; 
	m :: 1; 
	a :: 2; 
	s :: 3; 
	ELSE :: 4;
}

Rule :: struct {
	rating_type: RatingType;
	less_than: bool;
	value: int;
	next_workflow: string;
}

EvaluateRuleResult :: enum {
	REJECT;
	ACCEPT;
	SEND;
	CONTINUE;
}

evaluate_rule :: (r: Rule, pr: PartRating) -> EvaluateRuleResult {
	pass: bool;
	if r.rating_type == .ELSE {
		pass = true;
	}
	else if r.less_than {
		pass = pr[r.rating_type] < r.value;
	}
	else {
		pass = pr[r.rating_type] > r.value;
	}

	if pass {
		if r.next_workflow == "A" return .ACCEPT;
		else if r.next_workflow == "R" return .REJECT;
		else return .SEND;
	}
	else {
		return .CONTINUE;
	}
}

PartRange :: struct {
	min: [4]int;
	max: [4]int;
}

Workflow :: [..]Rule;
PartRating :: [4]int;

workflows: Table(string,Workflow);
part_ratings: [..]PartRating;
reading_workflows: bool;
run_main :: (suffix := "") -> int, int {
	
	table_reset(*workflows);
	array_reset(*part_ratings);
	reading_workflows = true;
	process_line :: (line: string) {
		if line.count == 0 {
			reading_workflows = false;
		}
		else if (reading_workflows) {
			workflow: Workflow;
			open_bracket_index := find_index_from_left(line,"{");
			ID := copy_string(slice(line,0,open_bracket_index));
			rules := split(slice(line,open_bracket_index+1,line.count-open_bracket_index-2),",");
			for rules {
				rule: Rule;
				colon_index := find_index_from_right(it,":");
				if colon_index != -1 {
					if it[0] == {
						case #char "x"; rule.rating_type = .x;
						case #char "m"; rule.rating_type = .m;
						case #char "a"; rule.rating_type = .a;
						case #char "s"; rule.rating_type = .s;
					}
					rule.less_than = it[1] == #char "<";
					num, success := string_to_int(slice(it,2,colon_index-2));
					assert(success);
					rule.value = num;
					rule.next_workflow = copy_string(slice(it,colon_index+1,line.count-colon_index-1));
				}
				else {
					rule.rating_type = .ELSE;
					rule.next_workflow = copy_string(it);
				}
				array_add(*workflow,rule);
			}
			table_set(*workflows,ID,workflow);
		}
		else {
			ratings := split(slice(line,1,line.count-2),",");
			assert(ratings.count == 4);
			part_rating: PartRating;
			for ratings {
				num, success := string_to_int(slice(it,2,line.count-2));
				assert(success);
				part_rating[it_index] = num;
			}
			array_add(*part_ratings,part_rating);
		}
	}
	process_file("day19", process_line, suffix);

	part1 := 0;

	for pr: part_ratings {
		workflow := table_find_pointer(*workflows, "in");
		while true {
			for rule: <<workflow {
				if evaluate_rule(rule, pr) == {
					case .ACCEPT;
						for pr {
							part1 += it;
						}
						continue pr;
					case .REJECT; 
						continue pr;
					case .SEND;
						workflow = table_find_pointer(*workflows, rule.next_workflow);
						break rule;
				}
			}
		}
	}


	determine_accepted :: (range: PartRange, workflow_id: string) -> int {
		if workflow_id == "A" {
			result := 1;
			for 0..3 {
				result *= range.max[it]-range.min[it]+1;
			}
			return result;
		}
		else if workflow_id == "R" {
			return 0;
		}

		workflow := table_find_pointer(*workflows, workflow_id);

		result := 0;
		remaining_range := range;
		for rule: <<workflow {
			if rule.rating_type == .ELSE {
				result += determine_accepted(remaining_range, rule.next_workflow);
			}
			else {
				new_range := remaining_range;
				if rule.less_than {
					if new_range.max[rule.rating_type] >= rule.value {
						new_range.max[rule.rating_type] = rule.value - 1;
						remaining_range.min[rule.rating_type] = rule.value;
					}
				}
				else {
					if new_range.min[rule.rating_type] <= rule.value {
						new_range.min[rule.rating_type] = rule.value + 1;
						remaining_range.max[rule.rating_type] = rule.value;
					}
				}
				result += determine_accepted(new_range, rule.next_workflow);
			}
		}

		return result;
	}

	part2 := determine_accepted(.{.[1,1,1,1],.[4000,4000,4000,4000]}, "in");

	return part1, part2;
}