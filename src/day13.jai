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
	print("Day13 Part1 Sample : %\n", run_main("sample"));
	print("Day13 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day13 Part2 Sample : %\n", run_main("sample"));
	//print("Day13 Part2        : %\n", run_main());
}

patterns: [..][..]string;
run_main :: (suffix := "") -> int {
	
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

	sum := 0;
	for pattern: patterns {
		for xfold: 1..pattern[0].count-1 {
			x1 := xfold-1;
			x2 := xfold;
			while x1 >= 0 && x2 < pattern[0].count {
				for y: 0..pattern.count-1 {
					if pattern[y][x1] != pattern[y][x2] {
						continue xfold;
					}
				}
				x1 -= 1;
				x2 += 1;
			}
			sum += xfold;
			continue pattern;
		}

		for yfold: 1..pattern.count-1 {
			y1 := yfold-1;
			y2 := yfold;
			while y1 >= 0 && y2 < pattern.count {
				for x: 0..pattern[0].count-1 {
					if pattern[y1][x] != pattern[y2][x] {
						continue yfold;
					}
				}
				y1 -= 1;
				y2 += 1;
			}
			sum += yfold * 100;
			continue pattern;
		}
	}

	return sum;
}