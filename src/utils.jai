#import "Basic";
#import "String";
#import "System";
#import "Text_File_Handler";

Parts :: enum u8 {
	PART1;
	PART2;
}

get_input_file_handler :: (day: string, suffix := "") -> Text_File_Handler
{
	handler: Text_File_Handler;
	handler.do_version_number = false;

	found, exe_path, exe_name := split_from_right(get_path_of_running_executable(), #char "/");
    if !found {
        print("Error: Unable to find my own executable?!\n");
    }
	else {
		filename := ifx suffix tprint("%_%.txt",day,suffix) else tprint("%.txt",day);
		filepath := tprint("%/../input/%", exe_path, filename);
	
		start_file(*handler, day, filepath, false);
	}
	return *handler;
}

process_file :: (day: string, func: (string), suffix := "") {
    handler := get_input_file_handler(day, suffix);
    defer deinit(*handler);

	if handler.failed {
		return;
	}

	while (true) {
        line, found := consume_next_line(*handler);
        if !found break;   // consume_next_line returns false for 'found' when we are done.

		func(line);
	}	
}

find_in_string :: (str: string, to_find: string, reverse := false) -> int {

	if to_find.count == 0 {
		return -1;
	}
	if to_find.count > str.count {
		return -1;
	}

	search_str := str;
	search_str.count = to_find.count;

	if reverse {
		search_str.data += str.count-to_find.count;
		for < str.count-to_find.count..0 {
			if search_str == to_find {
				return it;
			}
			search_str.data -= 1;
		}
	}
	else {
		for 0..str.count-to_find.count {
			if search_str == to_find {
				return it;
			}
			search_str.data += 1;
		}
	}

	return -1;
}

run_tests :: () {
	assert(find_in_string("hello","hello") == 0);
	assert(find_in_string("hello","hello",true) == 0);
	assert(find_in_string("hello","h") == 0);
	assert(find_in_string("hello","h", true) == 0);
	assert(find_in_string("hello","o") == 4);
	assert(find_in_string("hello","o", true) == 4);
	assert(find_in_string("hello","he") == 0);
	assert(find_in_string("hello","he", true) == 0);
	assert(find_in_string("hello","no") == -1);
	assert(find_in_string("hello","no",true) == -1);
	assert(find_in_string("hihi","hi") == 0);
	assert(find_in_string("hihi","hi",true) == 2);
}