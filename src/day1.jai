#import "Basic";
#import "utils";
#import "Text_File_Handler";

run :: () {
	run_sample();
	run_main();
}

get_value :: (line: string) -> int {

	value := 0;
	for 0..line.count-1 {
		if line[it] >= 48 && line[it] <= 57 {
			value += 10 * (line[it] - 48);
			break;
		}
	}
	for < line.count-1..0 {
		if line[it] >= 48 && line[it] <= 57 {
			value += (line[it] - 48);
			break;
		}
	}
	return value;
}

sample_sum := 0;
run_sample :: () {
	
	sum_sample_lines :: (line: string) {
		sample_sum += get_value(line);
	}

	process_file("day1", sum_sample_lines, true);
	print("Day1 Sample: %\n", sample_sum);

}

sum := 0;
run_main :: () {
	
	sum_lines :: (line: string) {
		sum += get_value(line);
	}

	process_file("day1", sum_lines);
	print("Day1: %\n", sum);

}