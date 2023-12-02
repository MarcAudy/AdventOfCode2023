#import "Basic";
#import "String";
#import "utils";

Part: Parts;
run :: () {
	
	Part = .PART1;
	print("Day2 Part1 Sample: %\n", run_main("sample"));
	print("Day2 Part1       : %\n", run_main());
}

validate_game :: (line: string) -> bool, int {

	colon_index := find_index_from_left(line,":");

	line_to_parse := slice(line,0,colon_index);

	game_id: int;
	assert(scan2(line_to_parse, "Game %", *game_id));

	start_index := colon_index;
	while(true) {
		semicolon_index := find_index_from_left(line,";",start_index+1);
		if semicolon_index == -1 { semicolon_index = line.count; }
		draw_details := slice(line,start_index+2,semicolon_index-start_index-2);
		cubes := split(draw_details,",");
		for *cubes { 
			<<it = trim(<<it);
			cube_count: int;
			if scan2(<<it, "% red", *cube_count) {
				if cube_count > 12 return false, -1;
			}
			if scan2(<<it, "% blue", *cube_count) {
				if cube_count > 14 return false, -1;
			}
			if scan2(<<it, "% green", *cube_count) {
				if cube_count > 13 return false, -1;
			}

		}
		if semicolon_index == line.count break;
		start_index = semicolon_index;
	}

	return true, game_id;
}

sum: int;
run_main :: (suffix := "") -> int {
	
	sum = 0;
	sum_lines :: (line: string) {
		is_valid_game, game_id := validate_game(line);
		if is_valid_game {
			sum += game_id;
		}
	}

	process_file("day2", sum_lines, suffix);

	return sum;
}