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
	print("Day8 Part1 Sample : %\n", run_main("sample"));
	print("Day8 Part1 Sample2: %\n", run_main("sample2"));
	print("Day8 Part1        : %\n", run_main());
	part = .PART2;
	print("Day8 Part2 Sample : %\n", run_main("part2_sample"));
	print("Day8 Part2        : %\n", run_main());
}

Node :: struct {
	left: string;
	right: string;
}

movements: string;
nodes: Table(string,Node);
run_main :: (suffix := "") -> int {
	
	movements = "";
	table_reset(*nodes);
	process_lines :: (line: string) {
		if movements.count == 0 {
			movements = tprint(line);
		}
		else if line.count > 0 {
			node_id := tprint(slice(line,0,3));
			node := table_add(*nodes,node_id,Node.{tprint(slice(line,7,3)),tprint(slice(line,12,3))});
		}
	}
	process_file("day8", process_lines, suffix);

	cur_node_ids: [..]string;
	found_z_steps: [..]int;

	if part == .PART1 {
		array_add(*cur_node_ids, "AAA");
		array_add(*found_z_steps, -1);
	}
	else {
		for node, node_id: nodes {
			if node_id[2] == #char "A" {
				array_add(*cur_node_ids, node_id);
				array_add(*found_z_steps, -1);
			}
		}
	}

	zs_found := 0;
	steps := 0;
	while outer := true {
		for cur_node_id: cur_node_ids {
			cur_node := table_find_pointer(*nodes, cur_node_id);
			cur_node_ids[it_index] = ifx movements[steps % movements.count] == # char "L" cur_node.left else cur_node.right;
		}
		steps += 1;
		if (part == .PART1) {
			if cur_node_ids[0] == "ZZZ" {
				return steps;
			}
		}
		else {
			for new_node_id: cur_node_ids {
				if new_node_id[2] == #char "Z" && found_z_steps[it_index] < 0 {
					found_z_steps[it_index] = steps;
					zs_found += 1;
					if zs_found == cur_node_ids.count {
						break outer;
					}
				}
			}
		}
	}

	get_gcd :: (a_in: int, b_in: int) -> int {
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

	quick_sort(found_z_steps, (a,b) => b-a);

	first_num := found_z_steps[0];
	for 1..found_z_steps.count-1 {
		second_num := found_z_steps[it];
		gcd := get_gcd(first_num, second_num);
		lcm := (first_num * second_num) / gcd;
		first_num = lcm;
	}

	return first_num;
}