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
	print("Day19 Part1 Sample : %\n", run_main("sample"));
	print("Day19 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day19 Part2 Sample : %\n", run_main("sample"));
	//print("Day19 Part2        : %\n", run_main());
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

Workflow :: struct {
	ID: string;
	rules: [..]Rule;
}

PartRating :: [4]int;

workflows: Table(string,Workflow);
part_ratings: [..]PartRating;
reading_workflows: bool;
run_main :: (suffix := "") -> int {
	
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
			workflow.ID = copy_string(slice(line,0,open_bracket_index));
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
				array_add(*workflow.rules,rule);
			}
			table_set(*workflows,workflow.ID,workflow);
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

	sum := 0;

	for pr: part_ratings {
		workflow := table_find_pointer(*workflows, "in");
		while true {
			for rule: workflow.rules {
				if evaluate_rule(rule, pr) == {
					case .ACCEPT;
						for pr {
							sum += it;
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

	return sum;
}