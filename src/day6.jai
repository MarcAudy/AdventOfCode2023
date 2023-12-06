#import "Basic";
#import "Hash_Table";
#import "Math";
#import "String";
#import "utils";

run :: () {
	print("Day6 Part1 Sample: %\n", run_main("sample"));
	print("Day6 Part1       : %\n", run_main());
}

AlmanacEntry :: struct {
	sourceStart: int;
	destStart: int;
	rangeLength: int;
}

Race :: struct {
	time: int;
	distance: int;
}

races: [..]Race;
run_main :: (suffix := "") -> int {
	
	array_reset(*races);
	process_lines :: (line: string) {
		race_index := 0;
		colon_index := find_index_from_left(line,":");
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
	process_file("day6", process_lines, suffix);

	total_ways_to_win := 1;

	for race: races {
		//print("%\n",race);
		ways_to_win_race := 0;
		for 1..race.time/2 {
			//print("Testing %\n",it);
			if it * (race.time-it) > race.distance {
				//print("Winning %: %\n",it,it * (race.time-it) > race.distance);
				ways_to_win_race += 1;
			}
		}
		ways_to_win_race *= 2;
		if race.time % 2 == 0 {
			ways_to_win_race -= 1;
		}
		//print("%\n",ways_to_win_race);
		total_ways_to_win *= ways_to_win_race;
	}

	return total_ways_to_win;
}