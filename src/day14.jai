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
	print("Day12 Part1 Sample : %\n", run_main("sample"));
	print("Day12 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day12 Part2 Sample : %\n", run_main("sample"));
	//print("Day12 Part2        : %\n", run_main());
}

Tile :: enum {
	EMPTY;
	MOVABLE;
	STATIC;
}

grid: [..][..]Tile;

print_grid :: () {
	for y: 0..grid.count-1 {
		for x: 0..grid[0].count {
			if grid[y][x] == {
				case .EMPTY; print(".");
				case .STATIC; print("#");
				case .MOVABLE; print("O");
			}
		}
		print("\n");
	}
}


run_main :: (suffix := "") -> int {
	
	array_reset(*grid);
	process_line :: (line: string) {
		row: [..]Tile;
		for cast([]u8) line {
			if it == {
				case #char "."; array_add(*row, .EMPTY);
				case #char "O"; array_add(*row, .MOVABLE);
				case #char "#"; array_add(*row, .STATIC);
				case; assert(false);
			}
		}
		array_add(*grid, row);
	}
	process_file("day14", process_line, suffix);

	//print_grid();

	for y: 1..grid.count-1 {
		for x: 0..grid[0].count {
			if grid[y][x] == .MOVABLE {
				for < y-1..0 {
					if grid[it][x] == .EMPTY {
						grid[it][x] = .MOVABLE;
						grid[it+1][x] = .EMPTY;
					}
					else {
						break;
					}
				}
			}
		}
	}
	
	//print("\n");
	//print_grid();

	sum := 0;
	for y: 0..grid.count-1 {
		for x: 0..grid[0].count {
			if grid[y][x] == .MOVABLE {
				sum += grid.count-y;
			}
		}
	}

	return sum;
}