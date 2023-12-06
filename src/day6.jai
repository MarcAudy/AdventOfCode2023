#import "Basic";
#import "Hash_Table";
#import "Math";
#import "String";
#import "utils";

part: Parts;
run :: () {
	part = .PART1;
	print("Day6 Part1 Sample: %\n", run_main("sample"));
	print("Day6 Part1       : %\n", run_main());
	part = .PART2;
	print("Day6 Part2 Sample: %\n", run_main("sample"));
	print("Day6 Part2       : %\n", run_main());
}

Race :: struct {
	time: int;
	distance: int;
}

races: [..]Race;
run_main :: (suffix := "") -> int {
	
	array_reset(*races);
	process_lines :: (line: string) {
		colon_index := find_index_from_left(line,":");
		if part == .PART1 {
			race_index := 0;
			for split(slice(line,colon_index+1,line.count-colon_index-1)," ") {
				num, success := string_to_int(it);
				if (success) {
					if races.count <= race_index {
						array_add(*races).time = num;
					}
					else {
						races[race_index].distance = num;
					}
					race_index += 1;
				}
			}
		}
		else {
			num := 0;
			for colon_index..line.count-1 {
				if is_digit(line[it]) {
					num *= 10;
					num += line[it] - #char "0";
				}
			}
			if races.count == 0 {
				array_add(*races).time = num;
			}
			else {
				races[0].distance = num;
			}
		}
	}
	process_file("day6", process_lines, suffix);

	total_ways_to_win := 1;

	for race: races {
		ways_to_win_race := 0;
		for 1..race.time/2 {
			if it * (race.time-it) > race.distance {
				ways_to_win_race += 1;
			}
		}
		ways_to_win_race *= 2;
		if race.time % 2 == 0 {
			ways_to_win_race -= 1;
		}
		total_ways_to_win *= ways_to_win_race;
	}

	return total_ways_to_win;
}