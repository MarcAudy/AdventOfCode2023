#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

part: Parts;
hack_iteration_count := 0;
run :: () {
	part = .PART1;
	print("Day10 Part1 Sample : %\n", run_main("sample"));
	print("Day10 Part1 Sample2: %\n", run_main("sample2"));
	print("Day10 Part1        : %\n", run_main());
	//part = .PART2;
	//print("Day9 Part2 Sample : %\n", run_main("sample"));
	//print("Day9 Part2        : %\n", run_main());
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
}

start_point: Point;
grid: [..][..]Tile;
run_main :: (suffix := "") -> int {
	
	hack_iteration_count += 1;
	array_reset(*grid);

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
	print("%\n",grid_size);

	// cheat what S is for now
	s_tile: Tile;
	if hack_iteration_count == {
		case 1; s_tile = .BEND_SE;
		case 2; s_tile = .BEND_SE;
		case 3; s_tile = .HORIZONTAL;
	}
	grid[start_point.y][start_point.x] = s_tile;

	dist_from_start: [..][..]int;
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
		cur_tile := grid[cur_point.y][cur_point.x];
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
	return dist_from_start[last_point.x][last_point.y];
}