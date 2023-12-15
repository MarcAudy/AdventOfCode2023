#import "Basic";
#import "Hash";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

run :: () {

	assert(hash_algo("HASH") == 52);

	sample_part1, sample_part2 := run_main("sample");
	part1, part2               := run_main();
	print("Day15 Part1 Sample: %\n", sample_part1);
	print("Day15 Part1       : %\n", part1);
	print("Day15 Part2 Sample: %\n", sample_part2);
	print("Day15 Part2       : %\n", part2);
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

Lens :: struct {
	id: string;
	focal_length: int;
}

puzzle: string;
run_main :: (suffix := "") -> int, int {
	
	process_line :: (line: string) {
		puzzle = copy_string(line);
	}
	process_file("day15", process_line, suffix);

	boxes: [256][..]Lens;
	part1_sum := 0;

	for split(puzzle,",") {
		part1_sum += hash_algo(it);

		if it[it.count-1] == #char "-" {
			lens_id := slice(it,0,it.count-1);
			box := hash_algo(lens_id);

			for lens, lens_index: boxes[box] {
				if lens.id == lens_id {
					array_ordered_remove_by_index(*boxes[box], lens_index);
					break;
				}
			}
		}
		else {
			lens_info := split(it,"=");
			assert(lens_info.count == 2);

			box := hash_algo(lens_info[0]);
			num, success := string_to_int(lens_info[1]);
			assert(success);
			found := false;
			for *lens: boxes[box] {
				if lens.id == lens_info[0] {
					lens.focal_length = num;
					found = true;
					break;
				}
			}
			if !found {
				array_add(*boxes[box],.{lens_info[0],num});
			}
		}
	}

	part2_sum := 0;
	for box, box_index: boxes {
		for lens, lens_index: box {
			part2_sum += (box_index+1) * (lens_index+1) * lens.focal_length;
		}
	}

	return part1_sum, part2_sum;
}