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
	print("Day9 Part1 Sample : %\n", run_main("sample"));
	print("Day9 Part1        : %\n", run_main());
	part = .PART2;
	print("Day9 Part2 Sample : %\n", run_main("sample"));
	print("Day9 Part2        : %\n", run_main());
}

sum: int;
run_main :: (suffix := "") -> int {
	
	sum = 0;
	process_lines :: (line: string) {
		diff_rows: [..][..]int;
		diffs: [..]int;
		for (split(line," ")) {
			num, success := string_to_int(it);
			if (success) {
				array_add(*diffs, num);
			}
		}
		array_add(*diff_rows,diffs);
		all_zeroes := false;
		while !all_zeroes {
			all_zeroes = true;
			new_diffs: [..]int;
			cur_diffs := diff_rows[diff_rows.count-1];
			for 1..cur_diffs.count-1 {
				new_diff := cur_diffs[it]-cur_diffs[it-1];
				array_add(*new_diffs,new_diff);
				if new_diff != 0 {
					all_zeroes = false;
				}
			}
			array_add(*diff_rows,new_diffs);
		}
		if part == .PART1 {
			last_row := diff_rows[diff_rows.count-1]; 
			array_add(*last_row,0);
			for < diff_rows.count-1..1 {
				cur_row := diff_rows[it-1];
				array_add(*cur_row,cur_row[cur_row.count-1]+last_row[last_row.count-1]);
				last_row = cur_row;
			}
			sum += last_row[last_row.count-1];
		}
		else {
			last_row := diff_rows[diff_rows.count-1]; 
			array_insert_at(*last_row,0,0);
			for < diff_rows.count-1..1 {
				cur_row := diff_rows[it-1];
				array_insert_at(*cur_row,cur_row[0]-last_row[0],0);
				last_row = cur_row;
			}
			sum += last_row[0];
		}
	}
	process_file("day9", process_lines, suffix);


	return sum;
}