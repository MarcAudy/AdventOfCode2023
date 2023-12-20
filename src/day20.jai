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
	//print("Day20 Part2 Sample : %\n", run_main("sample"));
	//print("Day20 Part2 Sample2: %\n", run_main("sample2"));
	//print("Day20 Part2        : %\n", run_main());
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

	for 1..1000 {
		pulses: [..]Pulse;
		array_add(*pulses,.{false,"button","broadcaster"});
		pulse_index := 0;
		while pulse_index < pulses.count {
			defer pulse_index += 1;
			
			pulse := pulses[pulse_index];
			module := table_find_pointer(*modules, pulse.dest);

			//print("% -%-> %\n",pulse.source,ifx pulse.high_pulse "high" else "low",pulse.dest);
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
						//print_table(*module.inputs);
						<<table_find_pointer(*module.inputs,pulse.source) = pulse.high_pulse;
						output := false;
						for module.inputs {
							if it == false {
								output = true;
								break;
							}
						}
						for module.destinations {
							array_add(*pulses,.{output,pulse.dest,it});
						}				
				}
				//print("%\n",array_view(pulses,pulse_index+1,pulses.count-pulse_index+1));
			}
		}
		//print("% %\n",low_count,high_count);
	}
	
	return low_count * high_count;
}