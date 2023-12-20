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
	print("Day20 Part1 Sample : %\n", run_main("sample"));
	print("Day20 Part1 Sample2: %\n", run_main("sample2"));
	print("Day20 Part1        : %\n", run_main());
	part = .PART2;
	print("Day20 Part2        : %\n", run_main());
}

ModuleType :: enum {
	BROADCASTER;
	FLIPFLOP;
	CONJUNCTION;
}

Module :: struct {
	type: ModuleType;
	destinations: [..]string;
	inputs: Table(string,bool); // CONJUNCTION only
	state: bool; // FLIPFLOP only
}

input_map: Table(string, [..]string);
modules: Table(string, Module);
run_main :: (suffix := "") -> int {
	
	table_reset(*modules);
	table_reset(*input_map);
	process_line :: (line: string) {
		module: Module;
		module_name: string;
		values := split(line," -> ");
		if values[0][0] == {
			case #char "%";
				module.type = .FLIPFLOP;
				module_name = copy_string(slice(values[0],1,values[0].count-1));
			case #char "&";
				module.type = .CONJUNCTION;
				module_name = copy_string(slice(values[0],1,values[0].count-1));
			case;
				assert(values[0] == "broadcaster");
				module.type = .BROADCASTER;
				module_name = copy_string(values[0]);
		}
		for split(values[1], ", ") {
			array_add(*module.destinations,copy_string(it));
			array_add(find_or_add(*input_map, it),module_name);
		}
		table_set(*modules,module_name,module);
	}
	process_file("day20", process_line, suffix);

	for *module, module_name: modules {
		if module.type == .CONJUNCTION {
			for <<table_find_pointer(*input_map, module_name) {
				table_set(*module.inputs,it,false);
			}
		}
	}

	low_count := 0;
	high_count := 0;

	Pulse :: struct {
		high_pulse: bool;
		source: string;
		dest: string;
	}

	// Part 2 might be completely generalizable but we'll hardcode some logic here based on our data
	// rx's input is tj and tj is a multiple conjunction, we need to identify when tj
	// will push a low signal to rx, which is when all of its inputs are high
	// this can be calculated as the LCM of the first time they are each high
	tj_module := table_find_pointer(*modules, "tj");
	tj_inputs_high: Table(string, int);

	button_press := 1;
	while true {
		pulses: [..]Pulse;
		array_add(*pulses,.{false,"button","broadcaster"});
		pulse_index := 0;
		while pulse_index < pulses.count {
			defer pulse_index += 1;
			
			pulse := pulses[pulse_index];
			module := table_find_pointer(*modules, pulse.dest);

			if pulse.high_pulse {
				high_count += 1;
			}
			else {
				low_count += 1;
			}

			if module {
				if module.type == {
					case .BROADCASTER;
						for module.destinations {
							array_add(*pulses,.{pulse.high_pulse,pulse.dest,it});
						}
					case .FLIPFLOP;
						if !pulse.high_pulse {
							module.state = !module.state;
							for module.destinations {
								array_add(*pulses,.{module.state,pulse.dest,it});
							}
						}
					case .CONJUNCTION;
						<<table_find_pointer(*module.inputs,pulse.source) = pulse.high_pulse;
						output := false;
						for high, module_name: module.inputs {
							if part == .PART2 && module == tj_module {
								if high {
									value, new := find_or_add(*tj_inputs_high,module_name);
									if new {
										<<value = button_press;
										if tj_inputs_high.count == module.inputs.count {										
											inputs_enabled: [..]int;
											for tj_inputs_high array_add(*inputs_enabled,it);
											return get_least_common_multiple(inputs_enabled);
										}
									}
								}
								else {
									output = true;
								}
							}
							else if !high {
								output = true;
								break;
							}
						}
						for module.destinations {
							array_add(*pulses,.{output,pulse.dest,it});
						}				
				}
			}
		}
		button_press += 1;
		if (part == .PART1) {
			if button_press == 1000 {
				return low_count * high_count;
			}
		}
	}
	
	return 0;
}