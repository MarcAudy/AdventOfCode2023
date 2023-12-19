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
	part = .PART1;
	print("Day18 Part1 Sample : %\n", run_main("sample"));
	print("Day18 Part1        : %\n", run_main());
	part = .PART2;
	print("Day18 Part2 Sample : %\n", run_main("sample"));
	print("Day18 Part2        : %\n", run_main());
}

Dirs :: enum {
	UP;
	DOWN;
	LEFT;
	RIGHT;
}

DigInstruction :: struct
{
	direction: Dirs;
	length: int;
}

dig_instructions: [..]DigInstruction;
run_main :: (suffix := "") -> int {
	
	array_reset(*dig_instructions);
	process_line :: (line: string) {
		di: DigInstruction;
		instruction_elements := split(line," ");
		if part == .PART1 {
			if line[0] == {
				case #char "U"; di.direction = .UP;
				case #char "D"; di.direction = .DOWN;
				case #char "L"; di.direction = .LEFT;
				case #char "R"; di.direction = .RIGHT;
			}
			success: bool;
			di.length, success = string_to_int(instruction_elements[1]);
			assert(success);
		}
		else {
			if instruction_elements[2][7] == {
				case #char "3"; di.direction = .UP;
				case #char "1"; di.direction = .DOWN;
				case #char "2"; di.direction = .LEFT;
				case #char "0"; di.direction = .RIGHT;
			}
			for 2..6 {
				di.length *= 16;
				if instruction_elements[2][it] <= #char "9" {
					di.length += instruction_elements[2][it] - #char "0";
				}
				else {
					di.length += instruction_elements[2][it] - #char "a" + 10;
				}
			}
		}
		array_add(*dig_instructions, di);
	}
	process_file("day18", process_line, suffix);

	cur_location := Point.{0,0};
	A := 1;
	trench_points := 1;

	for di: dig_instructions {
		next_location := cur_location;
		trench_points += di.length;
		if di.direction == {
			case .UP; 
				next_location.y -= di.length;

			case .DOWN;
				next_location.y += di.length;

			case .LEFT; 
				next_location.x -= di.length;

			case .RIGHT;
				next_location.x += di.length;
		}
		A += (next_location.x*cur_location.y)-(cur_location.x*next_location.y);
		cur_location = next_location;
	}

	return (abs(A)+trench_points)/2;
}