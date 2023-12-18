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
	print("Day18 Part1 Sample : %\n", run_main("sample"));
	print("Day18 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day18 Part2 Sample : %\n", run_main("sample"));
	//print("Day18 Part2        : %\n", run_main());
}

Dirs :: enum {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

DigInstruction :: struct
{
	direction: Dirs;
	length: int;
	color: string;
}

dig_instructions: [..]DigInstruction;
run_main :: (suffix := "") -> int {
	
	array_reset(*dig_instructions);
	process_line :: (line: string) {
		di: DigInstruction;
		if line[0] == {
			case #char "U"; di.direction = .UP;
			case #char "D"; di.direction = .DOWN;
			case #char "L"; di.direction = .LEFT;
			case #char "R"; di.direction = .RIGHT;
		}
		instruction_elements := split(line," ");
		success: bool;
		di.length, success = string_to_int(instruction_elements[1]);
		assert(success);

		di.color = copy_string(instruction_elements[2]);
		array_add(*dig_instructions, di);
	}
	process_file("day18", process_line, suffix);

	cur_location := Point.{0,0};
	dug_locations: Table(Point, bool, point_hash, compare_points);
	table_add(*dug_locations,cur_location,true);

	grid_min := cur_location;
	grid_max := cur_location;

	for di: dig_instructions {
		move_offset: Point;
		if di.direction == {
			case .UP; move_offset.y = -1;
			case .DOWN; move_offset.y = 1;
			case .LEFT; move_offset.x = -1;
			case .RIGHT; move_offset.x = 1;
		}
		for 1..di.length {
			cur_location += move_offset;
			table_set(*dug_locations, cur_location, true);
		}
		grid_min.x = min(grid_min.x,cur_location.x);
		grid_min.y = min(grid_min.y,cur_location.y);
		grid_max.x = max(grid_max.x,cur_location.x);
		grid_max.y = max(grid_max.y,cur_location.y);
	}

	outside_points: Table(Point, bool, point_hash, compare_points);
	points_to_consider: [..]Point;

	for x: grid_min.x..grid_max.x {
		cur_point := Point.{x,grid_min.y};
		if !table_contains(*dug_locations,cur_point) {
			_, new := find_or_add(*outside_points,cur_point);
			if new array_add(*points_to_consider, cur_point);
		}
		cur_point = Point.{x,grid_max.y};
		if !table_contains(*dug_locations,cur_point) {
			_, new := find_or_add(*outside_points,cur_point);
			if new array_add(*points_to_consider, cur_point);
		}
	}
	for y: grid_min.y..grid_max.y {
		cur_point := Point.{grid_min.x,y};
		if !table_contains(*dug_locations,cur_point) {
			_, new := find_or_add(*outside_points,cur_point);
			if new array_add(*points_to_consider, cur_point);
		}
		cur_point = Point.{grid_max.x,y};
		if !table_contains(*dug_locations,cur_point) {
			_, new := find_or_add(*outside_points,cur_point);
			if new array_add(*points_to_consider, cur_point);
		}
	}

	offsets :: Point.[.{-1,0},.{1,0},.{0,-1},.{0,1}];

	points_to_consider_index := 0;
	while points_to_consider_index < points_to_consider.count {
		point_to_consider := points_to_consider[points_to_consider_index];
		for offsets {
			cur_point := point_to_consider + it;
			if cur_point.x >= grid_min.x && cur_point.x <= grid_max.x &&
			   cur_point.y >= grid_min.y && cur_point.y <= grid_max.y {
				if !table_contains(*dug_locations,cur_point) {
					_, new := find_or_add(*outside_points,cur_point);
					if new array_add(*points_to_consider, cur_point);
				}
			}
		}
		points_to_consider_index += 1;
	}
/*
	for y: grid_min.y..grid_max.y {
		for x: grid_min.x..grid_max.x {
			print("%",ifx table_contains(*dug_locations,.{x,y}) "#" else ifx table_contains(*outside_points,.{x,y}) "O" else ".");
		}
		print("\n");
	}*/

	return (grid_max.x-grid_min.x+1)*(grid_max.y-grid_min.y+1) - outside_points.count;
}