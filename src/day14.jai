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

hash_grid :: () -> u32 {
	hash: u32 = 0;
	for grid {
		hash ^= get_hash(it);
	}
	return hash;
}

print_grid :: () {
	for y: 0..grid.count-1 {
		for x: 0..grid[0].count-1 {
			if grid[y][x] == {
				case .EMPTY; print(".");
				case .STATIC; print("#");
				case .MOVABLE; print("O");
			}
		}
		print("\n");
	}
}

seen_states: Table(u32, int);
run_main :: (suffix := "") -> int {
	
	array_reset(*grid);
	table_reset(*seen_states);

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

	iter := 0;
	found_cycle := false;
	while iter < 1000000000 {

		// NORTH
		for y: 1..grid.count-1 {
			for x: 0..grid[0].count-1 {
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
	
		// WEST
		for x: 1..grid[0].count-1 {
			for y: 0..grid.count-1 {
				if grid[y][x] == .MOVABLE {
					for < x-1..0 {
						if grid[y][it] == .EMPTY {
							grid[y][it] = .MOVABLE;
							grid[y][it+1] = .EMPTY;
						}
						else {
							break;
						}
					}
				}
			}
		}
	
		// SOUTH
		for < y: grid.count-2..0 {
			for x: 0..grid[0].count-1 {
				if grid[y][x] == .MOVABLE {
					for y+1..grid.count-1 {
						if grid[it][x] == .EMPTY {
							grid[it][x] = .MOVABLE;
							grid[it-1][x] = .EMPTY;
						}
						else {
							break;
						}
					}
				}
			}
		}
	
		// EAST
		for < x: grid[0].count-2..0 {
			for y: 0..grid.count-1 {
				if grid[y][x] == .MOVABLE {
					for x+1..grid[0].count-1 {
						if grid[y][it] == .EMPTY {
							grid[y][it] = .MOVABLE;
							grid[y][it-1] = .EMPTY;
						}
						else {
							break;
						}
					}
				}
			}
		}

		iter += 1;
		if (!found_cycle) {
			entry, new := find_or_add(*seen_states, hash_grid());
			if new {
				<<entry = iter;
			}
			else {
				print("cycle at % of %\n",iter,<<entry);
				found_cycle = true;
				num := (1000000000 - <<entry);
				period := iter - <<entry;
				iter = 1000000000 - (num % period);
				print("%\n",iter);
			}
		}
	}

	sum := 0;
	for y: 0..grid.count-1 {
		for x: 0..grid[0].count-1 {
			if grid[y][x] == .MOVABLE {
				sum += grid.count-y;
			}
		}
	}

	return sum;
}