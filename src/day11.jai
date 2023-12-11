#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

part: Parts;
run :: () {
	part = .PART1;
	print("Day11 Part1 Sample : %\n", run_main("sample"));
	print("Day11 Part1        : %\n", run_main());
	//part = .PART2;
	//print("Day11 Part2 Sample : %\n", run_main("sample"));
	//print("Day11 Part2        : %\n", run_main());
}


universe: [..][..]bool;
columns_with_galaxies: [..]bool;

print_universe :: () {
	for y: 0..universe.count-1 {
		for x: 0..universe[0].count-1 {
			print("%",ifx universe[y][x] "#" else ".");
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

		row : [..]bool;
		has_galaxy := false;
		for 0..line.count-1 {
			if line[it] == #char "#" {
				array_add(*row,true);
				has_galaxy = true;
				columns_with_galaxies[it] = true;
			}
			else {
				array_add(*row,false);
			}
		}
		array_add(*universe, row);
		if !has_galaxy {
			array_add(*universe, row);
		}
	}
	process_file("day11", process_lines, suffix);

	for < column_index: columns_with_galaxies.count-1..0 {
		if !columns_with_galaxies[column_index] {
			for universe {
				array_insert_at(*it, false, column_index);
			}
		}
	}

	galaxies: [..]Point;

	for y: 0..universe.count-1 {
		for x: 0..universe[0].count-1 {
			if universe[y][x] {
				array_add(*galaxies,.{x,y});
			}
		}
	}

	distances := 0;

	for galaxy1_index: 0..galaxies.count-2 {
		for galaxy2_index: galaxy1_index+1..galaxies.count-1 {
			distances += dist_between(galaxies[galaxy1_index],galaxies[galaxy2_index]);
		}
	}

	return distances;
}