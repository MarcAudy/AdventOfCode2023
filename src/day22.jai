#import "Basic";
#import "Hash";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

run :: () {
	sample_part1, sample_part2 := run_main("sample");
	part1, part2               := run_main();
	print("Day22 Part1 Sample: %\n", sample_part1);
	print("Day22 Part1       : %\n", part1);
	print("Day22 Part2 Sample: %\n", sample_part2);
	print("Day22 Part2       : %\n",part2);
}

x :: 0;
y :: 1;
z :: 2;

BrickCube :: struct {
	points: [2][3]int;
	at_rest: bool;
	resting_on: Table(*BrickCube,bool);
	supporting: Table(*BrickCube,bool);
}

debug_cubes :: () {
	debug_cubes(cubes);
}
debug_cubes :: (cubes: []*BrickCube) {
	for cubes {
		print("%: % % ",it,it.points,it.at_rest);
		print("(%) ",sprint_table(it.resting_on,","));
		print("(%)\n",sprint_table(it.supporting,","));
	}
	print("\n");
}

get_dependents :: (cube: *BrickCube) -> int {
	destroyed: Table(*BrickCube,bool);
	table_set(*destroyed,cube,true);
	
	to_consider: [..]*BrickCube;
	array_add(*to_consider,cube);

	consider_index := 0;

	while consider_index < to_consider.count {
		defer consider_index += 1;
		considering := to_consider[consider_index];

		for _, supported: considering.supporting {
			for _, resting_on: supported.resting_on {
				if !table_contains(*destroyed,resting_on) {
					continue supported;
				}
			}
			_, new := find_or_add(*destroyed,supported);
			if new {
				array_add(*to_consider,supported);
			}
		}
	}
	
	return destroyed.count-1;
}

cubes: [..]*BrickCube;
cubes_by_top: Table(int, [..]*BrickCube);
cubes_at_rest_count: int;
run_main :: (suffix := "") -> int, int {
	
	array_reset(*cubes);
	table_reset(*cubes_by_top);
	cubes_at_rest_count = 0;

	process_line :: (line: string) {
		cube := New(BrickCube);
		for split(line,"~") {
			point := *(cube.points[it_index]);
			for split(it,",") {
				num, success := string_to_int(it);
				assert(success);
				(<<point)[it_index] = num;
			}
		}
		for x..z {
			assert(cube.points[0][it] <= cube.points[1][it]);
		}
		array_add(*cubes,cube);
		array_add(find_or_add(*cubes_by_top,cube.points[1][z]),cube);
		insertion_sort(cubes, (a,b) => a.points[0][z] - b.points[0][z]);
	}
	process_file("day22", process_line, suffix);

	is_cube_on :: (cube: *BrickCube, support: *BrickCube) -> bool {
		if cube.points[0][z] != support.points[1][z]+1 {
			return false;
		}
		if ((cube.points[0][x] > support.points[1][x]) || (support.points[0][x] > cube.points[1][x])) {
			return false;
		}
		if ((cube.points[0][y] > support.points[1][y]) || (support.points[0][y] > cube.points[1][y])) {
			return false;
		}
		return true;
	}

	calc_cube_resting_on :: (cube: *BrickCube) {
		if cube.points[0][z] == 1 {
			cube.at_rest = true;
			cubes_at_rest_count += 1;
		}
		else {
			potential_supports, found := table_find(*cubes_by_top, cube.points[0][z]-1);
			if found {
				for potential_supports {
					if is_cube_on(cube, it) {
						table_set(*cube.resting_on,it,true);
						table_set(*it.supporting,cube,true);
						if it.at_rest && !cube.at_rest {
							cube.at_rest = true;
							cubes_at_rest_count += 1;
						}
					}
				}
			}
		}
	}

	for cubes {
		calc_cube_resting_on(it);
	}

	while cubes_at_rest_count < cubes.count {
		moving_cubes: [..]*BrickCube;
		for cube: cubes {
			if cube.at_rest continue;

			array_add(*moving_cubes, cube);
			for _, supported: cube.supporting {
				if supported.at_rest {
					assert(table_remove(*cube.supporting,supported));
					assert(table_remove(*supported.resting_on,cube));
				}
			}
		}
		for moving_cubes {
			assert(array_unordered_remove_by_value(table_find_pointer(*cubes_by_top,it.points[1][z]),it,true) == 1);
			it.points[0][z] -= 1;
			it.points[1][z] -= 1;
			array_add(find_or_add(*cubes_by_top,it.points[1][z]),it);
			calc_cube_resting_on(it);
		}		
	}

	part1 := 0;
	part2 := 0;
	for cube: cubes {
		for _, supported: cube.supporting {
			if supported.resting_on.count == 1 {
				part2 += get_dependents(cube);
				continue cube;
			}
		}
		part1 += 1;
	}

	return part1, part2;
}