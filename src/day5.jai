#import "Basic";
#import "Hash_Table";
#import "Math";
#import "String";
#import "utils";

Part: Parts;
run :: () {
	Part = .PART1;
	//print("Day5 Part1 Sample: %\n", run_main("sample"));
	//print("Day5 Part1       : %\n", run_main());
	Part = .PART2;
	print("Day5 Part2 Sample: %\n", run_main("sample"));
	print("Day5 Part2       : %\n", run_main());
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

	Range :: struct {
		start: int;
		length: int;
	}

	map_range :: (range_in: Range, entries: [..]AlmanacEntry) -> [..]Range {
		ranges: [..]Range;
		
		range := range_in;

		found := true;
		while outer := found {
			found = false;
			for entry: entries {
				using entry;
				if range.start >= sourceStart && range.start < sourceStart + rangeLength {
					newRangeStart := range.start - sourceStart + destStart;
					newRangeLength := min(sourceStart + rangeLength - range.start, range.length);
					array_add(*ranges,Range.{newRangeStart,newRangeLength});
					found = true;
					range.start += newRangeLength;
					range.length -= newRangeLength;
					if range.length == 0 {
						break outer;
					}
				}
			}
		}
		if range.length > 0 {
			array_add(*ranges,range);
		}
		return ranges;
	}

	seed_ranges: [..]Range;
	seed_index := 0;
	while seed_index < seeds.count {
		array_add(*seed_ranges,Range.{seeds[seed_index],seeds[seed_index+1]});
		seed_index += 2;
	}

	ranges := seed_ranges;
	for map: maps {
		new_ranges: [..]Range;
		for range: ranges {
			for new_range: map_range(range, map) {
				array_add(*new_ranges,new_range);
			}
		}
		ranges = new_ranges;
	}

	smallest_location := S64_MAX;
	for range: ranges {
		smallest_location = min(range.start,smallest_location);
	}

	return smallest_location;
}