#import "Basic";
Utils :: #import "utils";
Day1 :: #import "day1";
Day2 :: #import "day2";

main ::() {

	Utils.run_tests();

    start_time := get_time();
    defer {
        elapsed := get_time() - start_time;
        log("% ms elapsed.\n", elapsed * 1000);
    }
	//Day1.run();
	Day2.run();
}