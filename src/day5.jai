#import "Basic";
#import "Hash_Table";
#import "Math";
#import "String";
#import "utils";

run :: () {
	print("Day5 Part1 Sample: %\n", run_main("sample"));
	print("Day5 Part1       : %\n", run_main());
}

file_lines: [..] string;
run_main :: (suffix := "") -> int {
	
	array_reset(*file_lines);

	gather_lines :: (line: string) {
		array_add(*file_lines, tprint(line));
	}
	process_file("day5", gather_lines, suffix);

	seeds: [..] int;

	line := file_lines[0];
	colon_index := find_index_from_left(line,":");
	for split(slice(line,colon_index+1,line.count-colon_index-1)," ") {
		num, success := string_to_int(it);
		if (success) {
			array_add(*seeds, num);
		}
	}

	AlmanacEntry :: struct {
		sourceStart: int;
		destStart: int;
		rangeLength: int;
	}

	maps: [7] [..]AlmanacEntry;

	map_index := 0;
	line_index := 3;
	while line_index < file_lines.count {
		if file_lines[line_index].count == 0 {
			line_index += 2;
			map_index += 1;
			continue;
		}

		using almanac_entry: AlmanacEntry;
		assert(scan2(file_lines[line_index],"% % %",*destStart,*sourceStart,*rangeLength));
		array_add(*maps[map_index],almanac_entry);
		line_index += 1;
	}

	map_value :: (value: int, entries: [..]AlmanacEntry) -> int {
		for entry: entries {
			using entry;
			if value >= sourceStart && value < sourceStart + rangeLength {
				return value - sourceStart + destStart;
			}
		}
		return value;
	}

	smallest_location := S64_MAX;
	for seed: seeds {
		mapped_value := seed;
		for map: maps {
			mapped_value = map_value(mapped_value, map);
		}
		smallest_location = min(mapped_value,smallest_location);
	}

	return smallest_location;
}