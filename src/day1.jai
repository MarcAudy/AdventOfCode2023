#import "Basic";
#import "Sloppy_Math";
#import "utils";

digits: [10] string;
numbers: [10] string;

PART1 := true;
run :: () {
	
	digits[0] = "";
	digits[1] = "one";
	digits[2] = "two";
	digits[3] = "three";
	digits[4] = "four";
	digits[5] = "five";
	digits[6] = "six";
	digits[7] = "seven";
	digits[8] = "eight";
	digits[9] = "nine";

	for 0..9 {
		numbers[it] = tprint("%",it);
	}

	print("Day1 Part1 Sample: %\n", run_sample());
	print("Day1 Part1       : %\n", run_main());
	PART1 = false;
	print("Day1 Part2 Sample: %\n", run_sample());
	print("Day1 Part2       : %\n", run_main());
}



get_value :: (line: string) -> int {

	value := 0;

	if (PART1)
	{
		for 0..line.count-1 {
			if is_digit(line[it]) {
				value += 10 * (line[it] - #char "0");
				break;
			}
		}
		for < line.count-1..0 {
			if is_digit(line[it]) {
				value += (line[it] - #char "0");
				break;
			}
		}
	}
	else {
		firstDigit := -1;
		secondDigit := -1;
		firstDigitIndex := max_of_type(int);
		secondDigitIndex := -1;

		for digits {
			foundDigitIndex := find_in_string(line,it);
			if foundDigitIndex != -1 {
				if foundDigitIndex < firstDigitIndex {
					firstDigit = it_index;
					firstDigitIndex = foundDigitIndex;
				}
				foundDigitIndex = find_in_string(line,it,true);
				if foundDigitIndex > secondDigitIndex {
					secondDigit = it_index;
					secondDigitIndex = foundDigitIndex;
				}
			}
		}

		for numbers {
			foundDigitIndex := find_in_string(line,it);
			if foundDigitIndex != -1 {
				if foundDigitIndex < firstDigitIndex {
					firstDigit = it_index;
					firstDigitIndex = foundDigitIndex;
				}
				foundDigitIndex = find_in_string(line,it,true);
				if foundDigitIndex > secondDigitIndex {
					secondDigit = it_index;
					secondDigitIndex = foundDigitIndex;
				}
			}
		}

		value = firstDigit * 10 + secondDigit;
	}

	return value;
}

sample_sum: int;
run_sample :: () -> int {
	
	sample_sum = 0;
	sum_sample_lines :: (line: string) {
		sample_sum += get_value(line);
	}

	if (PART1) {
		process_file("day1", sum_sample_lines, "sample");
	}
	else {
		process_file("day1", sum_sample_lines, "part2_sample");
	}

	return sample_sum;
}

sum: int;
run_main :: () -> int {
	
	sum = 0;
	sum_lines :: (line: string) {
		sum += get_value(line);
	}

	process_file("day1", sum_lines);

	return sum;
}