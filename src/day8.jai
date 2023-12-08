#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "String";
#import "utils";

part: Parts;
run :: () {
	part = .PART1;
//	print("Day8 Part1 Sample : %\n", run_main("sample"));
//	print("Day8 Part1 Sample2: %\n", run_main("sample2"));
//	print("Day8 Part1        : %\n", run_main());
//	part = .PART2;
	print("Day8 Part2 Sample: %\n", run_main("part2_sample"));
	print("Day8 Part2       : %\n", run_main());
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

	for node, node_id: nodes {
		if node_id[2] == #char "A" {
			array_add(*cur_node_ids, node_id);
			array_add(*found_z_steps, -1);
		}
	}

	is_finished :: (node_ids: [..]string) -> bool {
		for node_ids {
			if it[2] == #char "Z" {
				
				return false;
			}
		}
		return true;
	}

	zs_found := 0;
	max_z_steps := 0;
	steps := 0;
	movement_index := 0;
	cur_node_id := "AAA";
	while outer := true {
		steps += 1;
		for cur_node_id: cur_node_ids {
			cur_node := table_find_pointer(*nodes, cur_node_id);
			cur_node_ids[it_index] = ifx movements[movement_index] == # char "L" cur_node.left else cur_node.right;
		}
		for new_node_id: cur_node_ids {
			if new_node_id[2] == #char "Z" {
				if (found_z_steps[it_index] < 0) {
					print("% found Z at step %\n",it_index,steps);
					found_z_steps[it_index] = steps;
					zs_found += 1;
					if steps > max_z_steps {
						max_z_steps = steps;
					}
					if zs_found == cur_node_ids.count {
						break outer;
					}
				}
			}
		}
		movement_index = (movement_index + 1) % movements.count;
	}

	result := max_z_steps;
	while outer := true {
		for found_z_steps {
			if result % it != 0 {
				result += max_z_steps;
				continue outer;
			}
		}
		break;
	}

	return result;
}