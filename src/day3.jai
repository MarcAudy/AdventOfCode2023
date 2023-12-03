#import "Basic";
#import "Hash_Table";
#import "String";
#import "utils";

run :: () {
	sample_part1, sample_part2 := run_main("sample");
	part1, part2               := run_main();
	print("Day3 Part1 Sample: %\n", sample_part1);
	print("Day3 Part1       : %\n", part1);
	print("Day3 Part2 Sample: %\n", sample_part2);
	print("Day3 Part2       : %\n", part2);
}

grid: [..]string;

run_main :: (suffix := "") -> int, int {
	
	array_reset(*grid);
	make_grid :: (line: string) {
		array_add(*grid, tprint("%",line));
	}
	process_file("day3", make_grid, suffix);

	gears: Table(Point, [..]int, point_hash, compare_points);

	part_number_sum := 0;
	for grid_index: 0..grid.count-1 {
		grid_line := grid[grid_index];
		index := 0;
		while index < grid_line.count {
			if is_digit(grid_line[index]) {
				num_start_index := index;
				num: int = grid_line[index] - #char "0";
				index += 1;
				while index < grid_line.count && is_digit(grid_line[index]) {
					num *= 10;
					num += grid_line[index] - #char "0";
					index += 1;
				}
				found := false;
				for y: max(0,grid_index-1)..min(grid.count-1,grid_index+1) {
					for x: max(0,num_start_index-1)..min(grid_line.count-1,index) {
						if grid[y][x] != #char "." && !is_digit(grid[y][x]) {
							if (!found) {
								found = true;
								part_number_sum += num;
							}
							if grid[y][x] == #char "*" {
								array_add(find_or_add(*gears, Point.{x,y}),num);
							}
						}
					}
				}

			}
			index += 1;
		}
	}

	gear_ratio_sum := 0;
	for gears {
		if it.count == 2 {
			gear_ratio_sum += it[0] * it[1];
		}
	}

	return part_number_sum, gear_ratio_sum;
}