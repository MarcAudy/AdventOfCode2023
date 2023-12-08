#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "String";
#import "utils";

part: Parts;
run :: () {
	part = .PART1;
	print("Day8 Part1 Sample: %\n", run_main("sample"));
	print("Day8 Part1       : %\n", run_main());
//	part = .PART2;
//	print("Day8 Part2 Sample: %\n", run_main("sample"));
//	print("Day8 Part2       : %\n", run_main());
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

	steps := 0;
	movement_index := 0;
	cur_node_id := "AAA";
	while cur_node_id != "ZZZ" {
		steps += 1;
		cur_node := table_find_pointer(*nodes, cur_node_id);
		cur_node_id = ifx movements[movement_index] == # char "L" cur_node.left else cur_node.right;
		movement_index = (movement_index + 1) % movements.count;
	}

	return steps;
}