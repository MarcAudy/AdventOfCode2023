#import "Basic";
#import "Hash";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

part: Parts;
run :: () {

	assert(hash_algo("HASH") == 52);

	part = .PART1;
	print("Day15 Part1 Sample : %\n", run_main("sample"));
	print("Day15 Part1        : %\n", run_main());
	part = .PART2;
	//print("Day15 Part2 Sample : %\n", run_main("sample"));
	//print("Day15 Part2        : %\n", run_main());
}

hash_algo :: (line: string) -> int {
	curValue := 0;
	for cast([]u8) line {
		curValue += it;
		curValue *= 17;
		curValue %= 256;
	}
	return curValue;
}

sum: int;
run_main :: (suffix := "") -> int {
	
	sum = 0;
	process_line :: (line: string) {
		for split(line,",") {
			sum += hash_algo(it);
		}
	}
	process_file("day15", process_line, suffix);

	return sum;
}