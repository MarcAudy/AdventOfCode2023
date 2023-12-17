#import "Basic";
#import "Hash";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "Sort";
#import "String";
#import "utils";

run :: () {
	sample_part1, sample_part2 := run_main("sample");
	part1, part2               := run_main();
	print("Day16 Part1 Sample: %\n", sample_part1);
	print("Day16 Part1       : %\n", part1);
	print("Day16 Part2 Sample: %\n", sample_part2);
	print("Day16 Part2       : %\n", part2);
}

Tile :: enum {
	EMPTY;
	HORIZONTAL;
	VERTICAL;
	SLASH;
	BACKSLASH;
}

Dirs :: enum {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

Beam :: struct {
	location: Point;
	direction: Dirs;
}
operator == :: (a: Beam, b: Beam) -> bool {
	return a.direction == b.direction && a.location == b.location;
}
compare_beams :: (a: Beam, b: Beam) -> bool {
	return a == b;
}
beam_hash :: (b: Beam) -> u32 {
	return sdbm_hash(*b, size_of(Beam));	
}

run_simulation :: (start_beam: Beam) -> int {

	beams: [..]Beam;
	array_add(*beams,start_beam);

	seen_beams: Table(Beam, bool, beam_hash, compare_beams);

	energized: [..][..]bool;
	energized_count := 0;

	array_resize(*energized,grid.count);
	for *energized {
		array_resize(it,grid[0].count);
	}

	while beams.count > 0 {
		for < beam_index: beams.count-1..0 {

			_, new := find_or_add(*seen_beams, beams[beam_index]);
			if !new {
				array_ordered_remove_by_index(*beams,beam_index);
				continue;
			}

			curPoint := *beams[beam_index].location;
			direction := beams[beam_index].direction;
			if direction == {
				case .RIGHT;
					curPoint.x += 1;
					if curPoint.x >= grid[0].count {
						array_ordered_remove_by_index(*beams,beam_index);
						continue;
					}
				case .LEFT;
					curPoint.x -= 1;
					if curPoint.x < 0 {
						array_ordered_remove_by_index(*beams,beam_index);
						continue;
					}
				case .UP;
					curPoint.y -= 1;
					if curPoint.y < 0 {
						array_ordered_remove_by_index(*beams,beam_index);
						continue;
					}
				case .DOWN;
					curPoint.y += 1;
					if curPoint.y >= grid.count {
						array_ordered_remove_by_index(*beams,beam_index);
						continue;
					}
			}
			if !energized[curPoint.y][curPoint.x] {
				energized[curPoint.y][curPoint.x] = true;
				energized_count += 1;
			}
			if grid[curPoint.y][curPoint.x] == {
				case .HORIZONTAL;
					if direction == .UP || direction == .DOWN {
						beams[beam_index].direction = .LEFT;
						array_add(*beams,.{<<curPoint,.RIGHT});
					}
				case .VERTICAL;
					if direction == .RIGHT || direction == .LEFT {
						beams[beam_index].direction = .UP;
						array_add(*beams,.{<<curPoint,.DOWN});
					}
				case .SLASH;
					if direction == {
						case .RIGHT; beams[beam_index].direction = .UP;
						case .UP; beams[beam_index].direction = .RIGHT;
						case .DOWN; beams[beam_index].direction = .LEFT;
						case .LEFT; beams[beam_index].direction = .DOWN;
					}
				case .BACKSLASH;
					if direction == {
						case .RIGHT; beams[beam_index].direction = .DOWN;
						case .UP; beams[beam_index].direction = .LEFT;
						case .DOWN; beams[beam_index].direction = .RIGHT;
						case .LEFT; beams[beam_index].direction = .UP;
					}
			}
		}
	}

	return energized_count;
}

grid: [..][..]Tile;
run_main :: (suffix := "") -> int, int {
	
	array_reset(*grid);
	process_line :: (line: string) {
		row: [..]Tile;
		for cast([]u8) line {
			if it == {
				case #char "."; array_add(*row, .EMPTY);
				case #char "-"; array_add(*row, .HORIZONTAL);
				case #char "|"; array_add(*row, .VERTICAL);
				case #char "/"; array_add(*row, .SLASH);
				case #char "\\"; array_add(*row, .BACKSLASH);
			}
		}
		array_add(*grid, row);
	}
	process_file("day16", process_line, suffix);

	part1_energized: int;
	part2_max_energized := 0;

	for y: 0..grid.count-1 {
		result := run_simulation(.{.{-1,y},.RIGHT});
		if y == 0 { part1_energized = result; }
		if result > part2_max_energized { part2_max_energized = result; }
		result = run_simulation(.{.{grid[0].count,y},.LEFT});
		if result > part2_max_energized { part2_max_energized = result; }
	}
	for x: 0..grid[0].count-1 {
		result := run_simulation(.{.{x,-1},.DOWN});
		if result > part2_max_energized { part2_max_energized = result; }
		result = run_simulation(.{.{x,grid.count},.UP});
		if result > part2_max_energized { part2_max_energized = result; }
	}

	return part1_energized, part2_max_energized;
}