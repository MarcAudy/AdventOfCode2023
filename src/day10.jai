#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

run :: () {

	part1, part2 :int;

	part1, part2 = run_main("sample");
	print("Day10 Part1 Sample : %\n", part1);
	print("Day10 Part2 Sample : %\n", part2);

	part1, part2 = run_main("sample2");
	print("Day10 Part1 Sample2: %\n", part1);
	print("Day10 Part2 Sample2: %\n", part2);

	part1, part2 = run_main("sample3");
	print("Day10 Part1 Sample3: %\n", part1);
	print("Day10 Part2 Sample3: %\n", part2);

	part1, part2 = run_main("sample4");
	print("Day10 Part1 Sample4: %\n", part1);
	print("Day10 Part2 Sample4: %\n", part2);

	part1, part2 = run_main("sample5");
	print("Day10 Part1 Sample5: %\n", part1);
	print("Day10 Part2 Sample5: %\n", part2);

    part1, part2 = run_main();
	print("Day10 Part1 : %\n", part1);
	print("Day10 Part2 : %\n", part2);
}

Tile :: enum {
	GROUND;
	VERTICAL;
	HORIZONTAL;
	BEND_NE;
	BEND_NW;
	BEND_SE;
	BEND_SW;
	START;
	OUTSIDE;
	INSIDE;
}

InitialPointMappings :: struct {
	start_tile: Tile;
	offsets: []Point;
	connector_tiles: [][]Tile;
}

initial_mappings :: InitialPointMappings.[
	.{.VERTICAL,.[.{0,-1},.{0,1}],.[.[.VERTICAL,.BEND_SE,.BEND_SW],.[.VERTICAL,.BEND_NE,.BEND_NW]]},
	.{.HORIZONTAL,.[.{-1,0},.{1,0}],.[.[.HORIZONTAL,.BEND_SE,.BEND_NE],.[.HORIZONTAL,.BEND_SW,.BEND_NW]]},
	.{.BEND_SE,.[.{0,1},.{1,0}],.[.[.VERTICAL,.BEND_NE,.BEND_NW],.[.HORIZONTAL,.BEND_SW,.BEND_NW]]},
	.{.BEND_SW,.[.{-1,0},.{0,1}],.[.[.HORIZONTAL,.BEND_SE,.BEND_NE],.[.VERTICAL,.BEND_NE,.BEND_NW]]},
	.{.BEND_NE,.[.{0,-1},.{1,0}],.[.[.VERTICAL,.BEND_SE,.BEND_SW],.[.HORIZONTAL,.BEND_SW,.BEND_NW]]},
	.{.BEND_NW,.[.{-1,0},.{0,-1}],.[.[.HORIZONTAL,.BEND_SE,.BEND_NE],.[.VERTICAL,.BEND_SE,.BEND_SW]]}
];

start_point: Point;
grid: [..][..]Tile;
dist_from_start: [..][..]int;
outside_points: [..]Point;

draw_grid :: () {
	for y: 0..grid.count-1 {
		for x: 0..grid[y].count-1 {
			if grid[y][x] == {
				case .GROUND; print(".");
				case .VERTICAL; print("|");
				case .HORIZONTAL; print("-");
				case .BEND_NE; print("L");
				case .BEND_NW; print("J");
				case .BEND_SE; print("F");
				case .BEND_SW; print("7");
				case .START; print("S");
				case .OUTSIDE; print("O");
			}
		}
		print("\n");
	}
}

is_in_grid :: (p: Point) -> bool {
	return p.x >= 0 && 
		   p.y >= 0 && 
		   p.x < grid[0].count && 
		   p.y < grid.count;
}

get_grid_tile :: (p: Point) -> Tile {
	return grid[p.y][p.x];
}

set_grid_tile :: (p: Point, t: Tile) {
	grid[p.y][p.x] = t;
}

run_main :: (suffix := "") -> int, int {
	
	array_reset(*grid);
	array_reset(*dist_from_start);
	array_reset(*outside_points);

	process_lines :: (line: string) {
		row: [..]Tile;
		for 0..line.count-1 {
			tile: Tile;
			if line[it] == {
				case #char "."; tile = .GROUND;
				case #char "|"; tile = .VERTICAL;
				case #char "-"; tile = .HORIZONTAL;
				case #char "L"; tile = .BEND_NE;
				case #char "J"; tile = .BEND_NW;
				case #char "F"; tile = .BEND_SE;
				case #char "7"; tile = .BEND_SW;
				case #char "S"; 
					tile = .START;
					start_point = Point.{it,grid.count};
			}
			array_add(*row,tile);
		}
		array_add(*grid,row);
	}
	process_file("day10", process_lines, suffix);

	grid_size := Point.{grid[0].count,grid.count};

	for mapping: initial_mappings {
		for mapping.offsets {
			if !is_in_grid(start_point+it) || !array_find(mapping.connector_tiles[it_index],get_grid_tile(start_point+it)) {
				continue mapping;
			}
		}
		set_grid_tile(start_point, mapping.start_tile);
		break;
	}

	array_resize(*dist_from_start,grid_size.x);
	for x: 0..grid_size.x-1 {
		array_resize(*dist_from_start[x],grid_size.y,false);
		for y: 0..grid_size.y-1 {
			dist_from_start[x][y] = -1;
		}
	}
	dist_from_start[start_point.x][start_point.y] = 0;

	points_to_consider: [..]Point;
	array_add(*points_to_consider, start_point);

	for cur_point: points_to_consider {
		next_points: [2]Point;
		cur_tile := get_grid_tile(cur_point);
		if cur_tile == {
			case .HORIZONTAL; 
				next_points[0] = Point.{cur_point.x-1,cur_point.y};
				next_points[1] = Point.{cur_point.x+1,cur_point.y};
			case .VERTICAL; 
				next_points[0] = Point.{cur_point.x,cur_point.y-1};
				next_points[1] = Point.{cur_point.x,cur_point.y+1};
			case .BEND_NE; 
				next_points[0] = Point.{cur_point.x,cur_point.y-1};
				next_points[1] = Point.{cur_point.x+1,cur_point.y};
			case .BEND_NW; 
				next_points[0] = Point.{cur_point.x,cur_point.y-1};
				next_points[1] = Point.{cur_point.x-1,cur_point.y};
			case .BEND_SE; 
				next_points[0] = Point.{cur_point.x,cur_point.y+1};
				next_points[1] = Point.{cur_point.x+1,cur_point.y};
			case .BEND_SW; 
				next_points[0] = Point.{cur_point.x,cur_point.y+1};
				next_points[1] = Point.{cur_point.x-1,cur_point.y};
		}
		for 0..1 {
			if dist_from_start[next_points[it].x][next_points[it].y] == -1 {
				dist_from_start[next_points[it].x][next_points[it].y] = dist_from_start[cur_point.x][cur_point.y] + 1;
				array_add(*points_to_consider,next_points[it]);
			}
		}
	}

	last_point := points_to_consider[points_to_consider.count-1];
	part1 := dist_from_start[last_point.x][last_point.y];

	is_in_loop :: (p: Point) -> bool {
		return dist_from_start[p.x][p.y] >= 0;
	}

	try_add_outside_point :: (p: Point) {
		if is_in_grid(p) && !is_in_loop(p) && get_grid_tile(p) != .OUTSIDE {
			set_grid_tile(p, .OUTSIDE);
			array_add(*outside_points, p);
		}
	}

	Dirs :: enum {
		UP;
		DOWN;
		LEFT;
		RIGHT;
	}

	outside_dir: Dirs;

	// Pick an arbitrary start point along the top
	// use the start_point column as we know that it will be in the loop
	outside_walk_start_point := Point.{start_point.x,0};
	for y: 0..grid.count-1 {
		if is_in_loop(outside_walk_start_point) {		
			if get_grid_tile(outside_walk_start_point) == {
				case .HORIZONTAL; #through;
				case .BEND_SW; outside_dir = .UP;
				case .BEND_SE; outside_dir = .LEFT;
				case; assert(false);
			}
			break;
		}
		else {
			try_add_outside_point(outside_walk_start_point);
			outside_walk_start_point.y += 1;
		}	
	}

	outside_walk_point := outside_walk_start_point;

	while true {
		if outside_dir == {
			case .UP;
				if get_grid_tile(outside_walk_point) == {
					case .HORIZONTAL;
						for x_offset: -1..1 {
							check_point := Point.{outside_walk_point.x+x_offset,outside_walk_point.y-1};
							try_add_outside_point(check_point);
						}
						outside_walk_point.x += 1;
					case .BEND_SW; 
						for x_offset: -1..1 {
							check_point := Point.{outside_walk_point.x+x_offset,outside_walk_point.y-1};
							try_add_outside_point(check_point);
						}
						outside_walk_point.y += 1;
						outside_dir = .RIGHT;
					case .BEND_NW;
						check_point := Point.{outside_walk_point.x-1,outside_walk_point.y-1};
						try_add_outside_point(check_point);
						outside_walk_point.y -= 1;
						outside_dir = .LEFT;
					case; assert(false);
				}
			case .DOWN;
				if get_grid_tile(outside_walk_point) == {
					case .HORIZONTAL;
						for x_offset: -1..1 {
							check_point := Point.{outside_walk_point.x+x_offset,outside_walk_point.y+1};
							try_add_outside_point(check_point);
						}
						outside_walk_point.x -= 1;
					case .BEND_NE; 
						for x_offset: -1..1 {
							check_point := Point.{outside_walk_point.x+x_offset,outside_walk_point.y+1};
							try_add_outside_point(check_point);
						}
						outside_walk_point.y -= 1;
						outside_dir = .LEFT;
					case .BEND_SE; 
						check_point := Point.{outside_walk_point.x+1,outside_walk_point.y+1};
						try_add_outside_point(check_point);
						outside_walk_point.y += 1;
						outside_dir = .RIGHT;
					case; assert(false);
				}
			case .RIGHT;
				if get_grid_tile(outside_walk_point) == {
					case .VERTICAL;
						for y_offset: -1..1 {
							check_point := Point.{outside_walk_point.x+1,outside_walk_point.y+y_offset};
							try_add_outside_point(check_point);
						}
						outside_walk_point.y += 1;
					case .BEND_NE; 
						check_point := Point.{outside_walk_point.x+1,outside_walk_point.y-1};
						try_add_outside_point(check_point);
						outside_walk_point.x += 1;
						outside_dir = .UP;
					case .BEND_NW;
						for y_offset: -1..1 {
							check_point := Point.{outside_walk_point.x+1,outside_walk_point.y+y_offset};
							try_add_outside_point(check_point);
						}
						outside_walk_point.x -= 1;
						outside_dir = .DOWN;
					case; assert(false);
				}
			case .LEFT;
				if get_grid_tile(outside_walk_point) == {
					case .VERTICAL;
						for y_offset: -1..1 {
							check_point := Point.{outside_walk_point.x-1,outside_walk_point.y+y_offset};
							try_add_outside_point(check_point);
						}
						outside_walk_point.y -= 1;
					case .BEND_SE; 
						for y_offset: -1..1 {
							check_point := Point.{outside_walk_point.x-1,outside_walk_point.y+y_offset};
							try_add_outside_point(check_point);
						}
						outside_walk_point.x += 1;
						outside_dir = .UP;
					case .BEND_SW;
						check_point := Point.{outside_walk_point.x-1,outside_walk_point.y+1};
						try_add_outside_point(check_point);
						outside_walk_point.x -= 1;
						outside_dir = .DOWN;
					case; assert(false);
				}	
		}

		if outside_walk_point == outside_walk_start_point {
			// We've made it to start again
			break;
		}
	}

	for outside_points {
		for x_offset: -1..1 {
			for y_offset: -1..1 {
				try_add_outside_point(.{it.x+x_offset,it.y+y_offset});
			}
		}
	}

	inside_count := grid_size.x * grid_size.y - outside_points.count - points_to_consider.count;

	return part1, inside_count;
}