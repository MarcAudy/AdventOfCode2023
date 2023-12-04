#import "Basic";
#import "Hash_Table";
#import "String";
#import "utils";

run :: () {
	print("Day4 Part1 Sample: %\n", run_part1("sample"));
	print("Day4 Part1       : %\n", run_part1());
	print("Day4 Part2 Sample: %\n", run_part2("sample"));
	print("Day4 Part2       : %\n", run_part2());
}

sum: int;
run_part1 :: (suffix := "") -> int {
	
	sum = 0;
	score_card :: (line: string) {
		score := 0;
		colon_index := find_index_from_left(line,":");
		pipe_index :=  find_index_from_left(line,"|");
		winning_nums: Table(int,bool);
		for split(slice(line,colon_index+1,pipe_index-colon_index-1)," ") {
			num, success := string_to_int(it);
			if (success) {
				table_add(*winning_nums, num, true);
			}
		}
		for split(slice(line,pipe_index+1,line.count-pipe_index)," ") {
			num, success := string_to_int(it);
			if (success) {
				if table_contains(*winning_nums, num) {
					if score > 0 score *= 2;
					else score = 1;
				}
			}
		}
		sum += score;
	}
	process_file("day4", score_card, suffix);
	return sum;
}

winners: [..] int;
run_part2 :: (suffix := "") -> int {

	array_reset(*winners);
	score_card :: (line: string) {

		score := 0;
		array_add(*winners, 0);

		colon_index := find_index_from_left(line,":");
		pipe_index :=  find_index_from_left(line,"|");

		winning_nums: Table(int,bool);
		for split(slice(line,colon_index+1,pipe_index-colon_index-1)," ") {
			num, success := string_to_int(it);
			if (success) {
				table_add(*winning_nums, num, true);
			}
		}
		for split(slice(line,pipe_index+1,line.count-pipe_index)," ") {
			num, success := string_to_int(it);
			if (success) {
				if table_contains(*winning_nums, num) {
					winners[winners.count-1] += 1;
				}
			}
		}
	}
	process_file("day4", score_card, suffix);

	visits: [..] int;
	for winners array_add(*visits,1);

	cards := 0;
	for winner, winner_index: winners {
		cards += visits[winner_index];
		for winner_index+1..winner_index+winner {
			visits[it] += visits[winner_index];
		}
	}

	return cards;
}