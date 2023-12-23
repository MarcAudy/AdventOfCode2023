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
	print("Day23 Part1 Sample : %\n", run_main("sample"));
	print("Day23 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day23 Part2 Sample : %\n", run_main("sample"));
	//print("Day23 Part2        : %\n", run_main());
}

Dirs :: enum {
	NONE;
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

MoveInfo :: struct {
	offset: Point;
	dir: Dirs;
}

Tile :: enum {
	PATH;
	FOREST;
	SLOPE_UP;
	SLOPE_LEFT;
	SLOPE_DOWN;
	SLOPE_RIGHT;
}

draw_grid :: () {
	for y: 0..grid.count-1 {
		for x: 0..grid[y].count-1 {
			if grid[y][x] == {
				case .PATH; print(".");
				case .FOREST; print("#");
				case .SLOPE_UP; print("^");
				case .SLOPE_DOWN; print("v");
				case .SLOPE_LEFT; print("<");
				case .SLOPE_RIGHT; print(">");
			}
		}
		print("\n");
	}
}

is_in_grid :: (p: Point) -> bool {
	return p.x > 0 && 
		   p.y >= 0 && 
		   p.x < grid[0].count && 
		   p.y < grid.count;
}

get_grid_tile :: (p: Point) -> Tile {
	return grid[p.y][p.x];
}

Scenario :: struct {
	location: Point;
	distance: int;
	visited: [][]bool;
}

start_point: Point;
target_point: Point;
grid: [..][..]Tile;
run_main :: (suffix := "") -> int {

	array_reset(*grid);
	process_line :: (line: string) {
		row: [..]Tile;
		for 0..line.count-1 {
			tile: Tile;
			if line[it] == {
				case #char "."; 
					tile = .PATH;
					if grid.count == 0 {
						start_point = .{it,0};
					}
					else {
						target_point = .{it,grid.count};
					}
				case #char "#"; tile = .FOREST;
				case #char "<"; tile = .SLOPE_LEFT;
				case #char ">"; tile = .SLOPE_RIGHT;
				case #char "^"; tile = .SLOPE_UP;
				case #char "v"; tile = .SLOPE_DOWN;
			}
			array_add(*row,tile);
		}
		array_add(*grid,row);
	}
	process_file("day23", process_line, suffix);

	scenario: Scenario;
	scenario.location = start_point;

	array_resize(*scenario.visited,grid.count);
	for *scenario.visited {
		array_resize(it,grid[0].count);
	}

	scenarios: [..]Scenario;
	array_add(*scenarios,scenario);

	moves :: MoveInfo.[
		.{.{-1,0},.LEFT},
		.{.{1,0},.RIGHT},
		.{.{0,-1},.UP},
		.{.{0,1},.DOWN}];

	is_valid_move :: (move: MoveInfo, scenario: Scenario) -> Point, bool {
		next_location := move.offset + scenario.location;
		if get_grid_tile(scenario.location) == {
			case .SLOPE_UP; if move.dir != .UP return next_location, false;
			case .SLOPE_DOWN; if move.dir != .DOWN return next_location, false;
			case .SLOPE_LEFT; if move.dir != .LEFT return next_location, false;
			case .SLOPE_RIGHT; if move.dir != .RIGHT return next_location, false;
		}
		return next_location, is_in_grid(next_location) && get_grid_tile(next_location) != .FOREST && !scenario.visited[next_location.y][next_location.x];
	}

	longest_walk := 0;
	
	while scenarios.count > 0 {
		
		scenario := pop(*scenarios);

		for move: moves {
			next_location, valid := is_valid_move(move,scenario);
			if valid {
				if next_location == target_point {
					longest_walk = max(longest_walk,scenario.distance+1);
				}
				else {
					new_visited := array_copy(scenario.visited);
					new_visited[next_location.y] = array_copy(scenario.visited[next_location.y]);
					new_visited[next_location.y][next_location.x] = true;
					array_add(*scenarios,.{next_location,scenario.distance+1,new_visited});
				}
			}
		}
	}

	return longest_walk;
}