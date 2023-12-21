#import "Basic";
#import "Hash";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

part: Parts;
step_count: int;
run :: () {
	part = .PART1;
	step_count = 6;
	print("Day21 Part1 Sample : %\n", run_main("sample"));
	step_count = 64;
	print("Day21 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day21 Part2 Sample : %\n", run_main("sample"));
	//print("Day21 Part2        : %\n", run_main());
}

Tile :: enum {
	START;
	PLOT;
	ROCK;
}

draw_grid :: () {
	for y: 0..grid.count-1 {
		for x: 0..grid[y].count-1 {
			if grid[y][x] == {
				case .PLOT; print(".");
				case .ROCK; print("#");
				case .START; print("S");
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

start_point: Point;
grid: [..][..]Tile;
run_main :: (suffix := "") -> int {
	
	array_reset(*grid);
	process_line :: (line: string) {
		row: [..]Tile;
		for 0..line.count-1 {
			tile: Tile;
			if line[it] == {
				case #char "."; tile = .PLOT;
				case #char "#"; tile = .ROCK;
				case #char "S"; 
					tile = .START;
					start_point = Point.{it,grid.count};
			}
			array_add(*row,tile);
		}
		array_add(*grid,row);
	}
	process_file("day21", process_line, suffix);

	cur_points: Table(Point, bool, point_hash, compare_points);
	table_set(*cur_points,start_point,true);

	moves :: Point.[.{-1,0},.{1,0},.{0,-1},.{0,1}];

	for 1..step_count {
		new_points: Table(Point, bool, point_hash, compare_points);
		for _, p: cur_points {
			for move: moves {
				new_p := p + move;
				if is_in_grid(new_p) && get_grid_tile(new_p) != .ROCK {
					table_set(*new_points,new_p,true);
				}
			}
		}
		cur_points = new_points;
	}

	return cur_points.count;
}