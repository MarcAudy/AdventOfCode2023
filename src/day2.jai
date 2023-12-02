#import "Basic";
#import "String";
#import "utils";

CUBE_RED :: 0;
CUBE_BLUE :: 1;
CUBE_GREEN :: 2;

Part: Parts;
run :: () {
	Part = .PART1;
	print("Day2 Part1 Sample: %\n", run_main("sample"));
	print("Day2 Part1       : %\n", run_main());
	Part = .PART2;
	print("Day2 Part2 Sample: %\n", run_main("sample"));
	print("Day2 Part1       : %\n", run_main());
}

min_cube_counts: [3] int;
score_game :: (line: string) -> int {

	for *min_cube_counts { <<it = 0; }

	colon_index := find_index_from_left(line,":");

	process_cubes_part1 :: (cube: string) -> bool {
		cube_count: int;
		if scan2(cube, "% red", *cube_count) {
			return cube_count <= 12;
		}
		else if scan2(cube, "% blue", *cube_count) {
			return cube_count <= 14;
		}
		else { 
			assert(scan2(cube, "% green", *cube_count));
			return cube_count <= 13;
		}
	}

	process_cubes_part2 :: (cube: string) -> bool {
		cube_count: int;
		if scan2(cube, "% red", *cube_count) {
			min_cube_counts[CUBE_RED] = max(min_cube_counts[CUBE_RED],cube_count);
		}
		else if scan2(cube, "% blue", *cube_count) {
			min_cube_counts[CUBE_BLUE] = max(min_cube_counts[CUBE_BLUE],cube_count);
		}
		else {
			assert(scan2(cube, "% green", *cube_count));
			min_cube_counts[CUBE_GREEN] = max(min_cube_counts[CUBE_GREEN],cube_count);
		}
		return true;
	}

	process_cubes := ifx Part == .PART1 process_cubes_part1 else process_cubes_part2;

	start_index := colon_index;
	while true {
		semicolon_index := find_index_from_left(line,";",start_index+1);
		if semicolon_index == -1 { semicolon_index = line.count; }
		draw_details := slice(line,start_index+2,semicolon_index-start_index-2);
		cubes := split(draw_details,",");
		for cubes { 
			if !process_cubes(trim(it)) {
				return 0;
			}
		}
		if semicolon_index == line.count break;
		start_index = semicolon_index;
	}

	if (Part == .PART1) {
		line_to_parse := slice(line,0,colon_index);
		game_id: int;
		assert(scan2(line_to_parse, "Game %", *game_id));
		return game_id;
	}
	else {
		return min_cube_counts[CUBE_RED] * min_cube_counts[CUBE_BLUE] * min_cube_counts[CUBE_GREEN];
	}
}

score: int;
run_main :: (suffix := "") -> int {
	
	score = 0;
	sum_scores :: (line: string) {
		score += score_game(line);
	}

	process_file("day2", sum_scores, suffix);

	return score;
}