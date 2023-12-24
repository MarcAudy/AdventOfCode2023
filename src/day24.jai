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
	print("Day24 Part1 Sample : %\n", run_main(7,27,"sample"));
	print("Day24 Part1        : %\n", run_main(200000000000000,400000000000000));
	part = .PART2;
	//print("Day24 Part2 Sample : %\n", run_main("sample"));
	//print("Day24 Part2        : %\n", run_main());
}

x :: 0;
y :: 1;
z :: 2;

HailStone :: struct {
	position: Vector3;
	velocity: Vector3;
}

Intersect2D :: ( P: Vector2, R: Vector2, Q: Vector2, S: Vector2 ) -> Vector2 {
    QP  := Q - P;
    SNV := Vector2.{S.y, -S.x};
    t  :=  dot(QP, SNV) / dot(R, SNV); 
    return P + (R * t);
}

hailstones: [..]HailStone;
run_main :: (area_min: float, area_max: float, suffix := "") -> int {

	array_reset(*hailstones);
	process_line :: (line: string) {
		components := split(line," @ ");
		using hs: HailStone;
		for split(components[0],", ") {
			num, success := string_to_int(it);
			assert(success);
			position.component[it_index] = cast(float) num;
		}
		for split(components[1],", ") {
			num, success := string_to_int(it);
			assert(success);
			velocity.component[it_index] = cast(float) num;
		}
		array_add(*hailstones,hs);
	}
	process_file("day24", process_line, suffix);

	is_in_future :: (hs: HailStone, v: Vector2) -> bool {
		if hs.velocity.x > 0 {
			if hs.position.x > v.x {
				return false;
			}
		}
		else if hs.position.x < v.x {
			return false;
		}
		if hs.velocity.y > 0 {
			if hs.position.y > v.y {
				return false;
			}
		}
		else if hs.position.y < v.y {
			return false;
		}
		return true;
	}

	in_area := 0;
	for hs1_index: 0..hailstones.count-2 {
		hs1 := hailstones[hs1_index];
		for hs2_index: hs1_index+1..hailstones.count-1 {
			hs2 := hailstones[hs2_index];
			intersection := Intersect2D(.{hs1.position.x,hs1.position.y},
										.{hs1.velocity.x,hs1.velocity.y},
										.{hs2.position.x,hs2.position.y},
										.{hs2.velocity.x,hs2.velocity.y});

			if !isinf(intersection.x) && 
			   !isinf(intersection.y) &&
			   intersection.x >= area_min && intersection.x <= area_max &&
			   intersection.y >= area_min && intersection.y <= area_max &&
			   is_in_future(hs1, intersection) && 
			   is_in_future(hs2, intersection) {
			   in_area += 1;
			}
		}
	}

	return in_area;
}