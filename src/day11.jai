#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

part: Parts;
expanded_size: int;
run :: () {
	part = .PART1;
	expanded_size = 2;
	print("Day11 Part1 Sample : %\n", run_main("sample"));
	print("Day11 Part1        : %\n", run_main());
	part = .PART2;
	expanded_size = 10;
	print("Day11 Part2 Sample : %\n", run_main("sample"));
	expanded_size = 100;
	print("Day11 Part2 Sample2: %\n", run_main("sample"));
	expanded_size = 1000000;
	print("Day11 Part2        : %\n", run_main());
}


galaxies: [..]Point;
universe: [..][..]int;
columns_with_galaxies: [..]bool;
expanded_row: [..]int;

run_main :: (suffix := "") -> int {
	
	array_reset(*galaxies);
	array_reset(*universe);
	array_reset(*columns_with_galaxies);
	array_reset(*expanded_row);

	process_lines :: (line: string) {
		if columns_with_galaxies.count == 0 {
			array_resize(*columns_with_galaxies,line.count);
			array_reserve(*expanded_row,line.count);
			for columns_with_galaxies {
				array_add(*expanded_row,expanded_size);
			}
		}

		row : [..]int;
		has_galaxy := false;
		for 0..line.count-1 {
			array_add(*row,1);
			if line[it] == #char "#" {
				has_galaxy = true;
				columns_with_galaxies[it] = true;
				array_add(*galaxies,.{it,universe.count});
			}
		}
		array_add(*universe, ifx has_galaxy row else expanded_row);
	}
	process_file("day11", process_lines, suffix);

	for column_has_galaxy, column_index: columns_with_galaxies {
		if !column_has_galaxy {
			for universe {
				it[column_index] = expanded_size;
			}
		}
	}

	distances := 0;

	for galaxy1_index: 0..galaxies.count-2 {
		g1 := galaxies[galaxy1_index];
		for galaxy2_index: galaxy1_index+1..galaxies.count-1 {
			g2 := galaxies[galaxy2_index];
			for x: min(g1.x,g2.x)+1..max(g1.x,g2.x) {
				distances += universe[g1.y][x];
			}
			for y: min(g1.y,g2.y)+1..max(g1.y,g2.y) {
				distances += universe[y][g1.x];
			}
		}
	}

	return distances;
}