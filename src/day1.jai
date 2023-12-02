#import "Basic";
#import "Sloppy_Math";
#import "utils";

digits: [10] string;

Part: Parts;
run :: () {
	
	digits[1] = "one";
	digits[2] = "two";
	digits[3] = "three";
	digits[4] = "four";
	digits[5] = "five";
	digits[6] = "six";
	digits[7] = "seven";
	digits[8] = "eight";
	digits[9] = "nine";

	Part = .PART1;
	print("Day1 Part1 Sample: %\n", run_main("sample"));
	print("Day1 Part1       : %\n", run_main());
	Part = .PART2;
	print("Day1 Part2 Sample: %\n", run_main("part2_sample"));
	print("Day1 Part2       : %\n", run_main());
}

get_value :: (line: string) -> int {
	get_digit :: (line: string, index: int) -> int {
		test_digit :: (line: string, index: int, digit: int) -> bool {
			if index <= line.count-digits[digit].count {
				for 1..digits[digit].count-1 {
					if line[index+it] != digits[digit][it] {
						return false;
					}
				}
				return true;
			}
			return false;
		}

		if is_digit(line[index]) {
			return (line[index] - #char "0");
		}
		else if Part == .PART2 {
			if line[index] == {
				case #char "o";
					if test_digit(line, index, 1) return 1;
				case #char "t";
					if test_digit(line, index, 2) return 2;
					if test_digit(line, index, 3) return 3;
				case #char "f";
					if test_digit(line, index, 4) return 4;
					if test_digit(line, index, 5) return 5;
				case #char "s";
					if test_digit(line, index, 6) return 6;
					if test_digit(line, index, 7) return 7;
				case #char "e";
					if test_digit(line, index, 8) return 8;
				case #char "n";
					if test_digit(line, index, 9) return 9;
			}
		}
		return -1;
	}

	value := 0;

	for 0..line.count-1 {
		digit := get_digit(line,it);
		if digit != -1 {
			value += 10 * digit;
			break;
		}
	}
	for < line.count-1..0 {
		digit := get_digit(line,it);
		if digit != -1 {
			value += digit;
			break;
		}
	}

	return value;
}

sum: int;
run_main :: (suffix := "") -> int {
	
	sum = 0;
	sum_lines :: (line: string) {
		sum += get_value(line);
	}

	process_file("day1", sum_lines, suffix);

	return sum;
}