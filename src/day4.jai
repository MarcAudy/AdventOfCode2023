#import "Basic";
#import "Hash_Table";
#import "String";
#import "utils";

run :: () {
	sample_part1, sample_part2 := run_main("sample");
	part1, part2               := run_main();
	print("Day4 Part1 Sample: %\n", sample_part1);
	print("Day4 Part1       : %\n", part1);
	print("Day4 Part2 Sample: %\n", sample_part2);
	print("Day4 Part2       : %\n", part2);
}

sum: int;
winners: [..] int;
run_main :: (suffix := "") -> int, int {
	
	sum = 0;
	array_reset(*winners);

	score_card :: (line: string) {
		
		colon_index := find_index_from_left(line,":");
		pipe_index :=  find_index_from_left(line,"|");
		winning_nums: Table(int,bool);
		for split(slice(line,colon_index+1,pipe_index-colon_index-1)," ") {
			num, success := string_to_int(it);
			if (success) {
				table_add(*winning_nums, num, true);
			}
		}
		winning_num_count := 0;
		for split(slice(line,pipe_index+1,line.count-pipe_index)," ") {
			num, success := string_to_int(it);
			if (success) {
				if table_contains(*winning_nums, num) {
					winning_num_count += 1;
				}
			}
		}
		array_add(*winners, winning_num_count);
		if winning_num_count > 0 {
			sum += 1 << (winning_num_count-1);
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

	return sum, cards;
}