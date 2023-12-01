#import "Basic";
#import "String";
#import "System";
#import "Text_File_Handler";

get_input_file_handler :: (day: string, sample := false) -> Text_File_Handler
{
	handler: Text_File_Handler;
	handler.do_version_number = false;

	found, exe_path, exe_name := split_from_right(get_path_of_running_executable(), #char "/");
    if !found {
        print("Error: Unable to find my own executable?!\n");
    }
	else {
		filename := ifx sample then tprint("%_sample.txt",day) else tprint("%.txt",day);
		filepath := tprint("%/../input/%", exe_path, filename);
	
		start_file(*handler, day, filepath, false);
	}
	return *handler;
}

process_file :: (day: string, func: (string), sample := false) {
    handler := get_input_file_handler("day1", sample);
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