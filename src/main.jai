#import "Basic";
Utils :: #import "utils";

Day1 :: #import "day1";
Day2 :: #import "day2";
Day3 :: #import "day3";
Day4 :: #import "day4";
Day5 :: #import "day5";
Day6 :: #import "day6";
Day7 :: #import "day7";
Day8 :: #import "day8";
Day9 :: #import "day9";
Day10 :: #import "day10";
Day11 :: #import "day11";
Day12 :: #import "day12";
Day13 :: #import "day13";
Day14 :: #import "day14";
Day15 :: #import "day15";
Day16 :: #import "day16";
//Day17 :: #import "day17";
Day18 :: #import "day18";
Day19 :: #import "day19";
Day20 :: #import "day20";
//Day21 :: #import "day21";
Day22 :: #import "day22";
//Day23 :: #import "day23";
Day24 :: #import "day24";
//Day25 :: #import "day25";

main ::() {

	Utils.run_tests();

    start_time := seconds_since_init();
    defer {
        elapsed := seconds_since_init() - start_time;
        log("% ms elapsed.\n", elapsed * 1000);
    }
	
	Day1.run();
	Day2.run();
	Day3.run();
	Day4.run();
	Day5.run();
	Day6.run();
	Day7.run();
	Day8.run();
	Day9.run();
	Day10.run();
	Day11.run();
	Day12.run();
	Day13.run();
	Day14.run();
	Day15.run();
	Day16.run();
	//Day17.run();
	Day18.run();
	Day19.run();
	Day20.run();
	//Day21.run();
	Day22.run();
	//Day23.run();
	Day24.run();
	//Day25.run();
}