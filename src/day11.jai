#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

part: Parts;
expansion: int;
run :: () {
	part = .PART1;
	expansion = 1;
	print("Day11 Part1 Sample : %\n", run_main("sample"));
	print("Day11 Part1        : %\n", run_main());
	part = .PART2;
	expansion = 9;
	print("Day11 Part2 Sample : %\n", run_main("sample"));
	expansion = 99;
	print("Day11 Part2 Sample2: %\n", run_main("sample"));
	expansion = 999999;
	print("Day11 Part2        : %\n", run_main());
}


universe: [..][..]int;
columns_with_galaxies: [..]bool;

print_universe :: () {
	for y: 0..universe.count-1 {
		for x: 0..universe[0].count-1 {
			if universe[y][x] == -1
				print("#");
			else if universe[y][x] == 1
				print(".");
			else if universe[y][x] == expansion
				print("@");
		}
		print("\n");
	}
}

run_main :: (suffix := "") -> int {
	
	array_reset(*universe);
	array_reset(*columns_with_galaxies);

	process_lines :: (line: string) {
		if columns_with_galaxies.count == 0 {
			array_resize(*columns_with_galaxies,line.count);
		}

		row : [..]int;
		has_galaxy := false;
		for 0..line.count-1 {
			if line[it] == #char "#" {
				array_add(*row,-1);
				has_galaxy = true;
				columns_with_galaxies[it] = true;
			}
			else {
				array_add(*row,1);
			}
		}
		array_add(*universe, row);
		if !has_galaxy {
			if part == .PART1 {
				array_add(*universe, row);
			}
			else {
				expanded_row: [..]int;
				for 0..line.count-1 {
					array_add(*expanded_row,expansion);
				}
				array_add(*universe, expanded_row);
			}
		}
	}
	process_file("day11", process_lines, suffix);

	for < column_index: columns_with_galaxies.count-1..0 {
		if !columns_with_galaxies[column_index] {
			for universe {
				array_insert_at(*it, ifx part == .PART1 1 else expansion, column_index);
			}
		}
	}

	galaxies: [..]Point;

	for y: 0..universe.count-1 {
		for x: 0..universe[0].count-1 {
			if universe[y][x] == -1 {
				array_add(*galaxies,.{x,y});
			}
		}
	}

	distances := 0;

	for galaxy1_index: 0..galaxies.count-2 {
		g1 := galaxies[galaxy1_index];
		for galaxy2_index: galaxy1_index+1..galaxies.count-1 {
			g2 := galaxies[galaxy2_index];
			dist := 0;
			for x: min(g1.x,g2.x)+1..max(g1.x,g2.x) {
				distances += abs(universe[g1.y][x]);
			}
			for y: min(g1.y,g2.y)+1..max(g1.y,g2.y) {
				distances += abs(universe[y][g1.x]);
			}
		}
	}

	return distances;
}