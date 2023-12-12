#import "Basic";
Utils :: #import "utils";
/*
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
*/
Day12 :: #import "day12";

main ::() {

	Utils.run_tests();

    start_time := get_time();
    defer {
        elapsed := get_time() - start_time;
        log("% ms elapsed.\n", elapsed * 1000);
    }
	/*
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
	*/
	Day12.run();
}