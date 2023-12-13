#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

run :: () {
	sample_part1, sample_part2 := run_main("sample");
	part1, part2               := run_main();
	print("Day13 Part1 Sample: %\n", sample_part1);
	print("Day13 Part1       : %\n", part1);
	print("Day13 Part2 Sample: %\n", sample_part2);
	print("Day13 Part2       : %\n", part2);
}

patterns: [..][..]string;
run_main :: (suffix := "") -> int, int {
	
	array_resize(*patterns,1);
	array_reset(*patterns[0]);
	process_line :: (line: string) {
		if line.count == 0 { 
			array_resize(*patterns,patterns.count+1);
		}
		else {
			array_add(*patterns[patterns.count-1],copy_string(line));
		}
	}
	process_file("day13", process_line, suffix);

	part1_sum := 0;
	part2_sum := 0;
	for pattern: patterns {

		found_part1 := false;
		found_part2 := false;

		for xfold: 1..pattern[0].count-1 {
			errors := 0;
			x1 := xfold-1;
			x2 := xfold;
			while x1 >= 0 && x2 < pattern[0].count {
				for y: 0..pattern.count-1 {
					if pattern[y][x1] != pattern[y][x2] {
						errors += 1;
						if errors > 1 {
							continue xfold;
						}
					}
				}
				x1 -= 1;
				x2 += 1;
			}
			if errors == 0 {
				part1_sum += xfold;
				if found_part2 {
					continue pattern;
				}
				found_part1 = true;
			}
			else {			
				part2_sum += xfold;
				if found_part1 {
					continue pattern;
				}
				found_part2 = true;
			}
			
		}

		for yfold: 1..pattern.count-1 {
			errors := 0;
			y1 := yfold-1;
			y2 := yfold;
			while y1 >= 0 && y2 < pattern.count {
				for x: 0..pattern[0].count-1 {
					if pattern[y1][x] != pattern[y2][x] {
						errors += 1;
						if errors > 1 {
							continue yfold;
						}
					}
				}
				y1 -= 1;
				y2 += 1;
			}
			if errors == 0 {
				part1_sum += yfold * 100;
				if found_part2 {
					continue pattern;
				}
				found_part1 = true;
			}
			else {
				part2_sum += yfold * 100;
				if found_part1 {
					continue pattern;
				}
				found_part2 = true;
			}
		}
	}

	return part1_sum, part2_sum;
}