#import "Basic";
#import "String";
#import "utils";

run :: () {
	print("Day3 Part1 Sample: %\n", run_main("sample"));
	print("Day3 Part1       : %\n", run_main());
}

grid: [..]string;

run_main :: (suffix := "") -> int {
	
	array_reset(*grid);
	make_grid :: (line: string) {
		array_add(*grid, tprint("%",line));
	}
	process_file("day3", make_grid, suffix);

	sum := 0;
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
				for y: max(0,grid_index-1)..min(grid.count-1,grid_index+1) {
					for x: max(0,num_start_index-1)..min(grid_line.count-1,index) {
						if grid[y][x] != #char "." && !is_digit(grid[y][x]) {
							sum += num;
							break y;
						}
					}
				}

			}
			index += 1;
		}
	}

	return sum;
}