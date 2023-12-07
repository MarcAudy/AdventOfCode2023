#import "Basic";
#import "Hash_Table";
#import "IntroSort";
#import "Math";
#import "String";
#import "utils";

part: Parts;
run :: () {
	part = .PART1;
	print("Day7 Part1 Sample: %\n", run_main("sample"));
	print("Day7 Part1       : %\n", run_main());
	part = .PART2;
	print("Day6 Part2 Sample: %\n", run_main("sample"));
	print("Day6 Part2       : %\n", run_main());
}

HandType :: enum {
	UNKNOWN;
	HIGH_CARD;
	ONE_PAIR;
	TWO_PAIR;
	THREE_OF_A_KIND;
	FULL_HOUSE;
	FOUR_OF_A_KIND;
	FIVE_OF_A_KIND;
}

Hand :: struct {
	cards: [5]u8;
	bid: int;
	hand_type: HandType;
}

hands: [..] Hand;
run_main :: (suffix := "") -> int {
	
	array_reset(*hands);
	process_lines :: (line: string) {
		hand := array_add(*hands);
		card_counts: Table(u8,u8);
		joker_count := 0;
		for 0..4 {
			if line[it] == {
			case #char "J"; 
				if part == .PART1 {
					hand.cards[it] = 11;
				}
				else {
					hand.cards[it] = 1;
					joker_count += 1;
				}
			case #char "A"; hand.cards[it] = 14;
			case #char "K"; hand.cards[it] = 13;
			case #char "Q"; hand.cards[it] = 12;
			case #char "T"; hand.cards[it] = 10;
			case; hand.cards[it] = line[it] - #char "0";
			}
			<<find_or_add(*card_counts, hand.cards[it]) += 1;
		}
		for count, card: card_counts {
			if card != 1 {
				if count == {
				case 5; 
					hand.hand_type = .FIVE_OF_A_KIND; break;
				case 4;
					hand.hand_type = .FOUR_OF_A_KIND; break;
				case 3; 
					if hand.hand_type == {
					case .UNKNOWN;
						hand.hand_type = .THREE_OF_A_KIND;
					case .HIGH_CARD;
						hand.hand_type = .THREE_OF_A_KIND; break;
					case .ONE_PAIR; 
						hand.hand_type = .FULL_HOUSE; break;
					case;
						assert(false); 
					}
				case 2;
					if hand.hand_type == {
					case .UNKNOWN; #through;
					case .HIGH_CARD;
						hand.hand_type = .ONE_PAIR;
					case .ONE_PAIR;
						hand.hand_type = .TWO_PAIR; break;
					case .THREE_OF_A_KIND; 
						hand.hand_type = .FULL_HOUSE; break;
					case;
						assert(false); 
					}
				case 1;
					if hand.hand_type == .UNKNOWN {
						hand.hand_type = .HIGH_CARD;
					}
				}
			}
		}
		if joker_count > 0 {
			if #complete hand.hand_type == {
			case .FIVE_OF_A_KIND;
				assert(false);
			case .FOUR_OF_A_KIND;
				if joker_count == 1 hand.hand_type = .FIVE_OF_A_KIND;
				else assert(joker_count == 0);
			case .FULL_HOUSE; 
				assert(false);
			case .THREE_OF_A_KIND;
				if joker_count == {
				case 2; hand.hand_type = .FIVE_OF_A_KIND;
				case 1; hand.hand_type = .FOUR_OF_A_KIND;
				case; assert(joker_count == 0);
				}
			case .TWO_PAIR;
				if joker_count == 1 hand.hand_type = .FULL_HOUSE;
				else assert(joker_count == 0);
			case .ONE_PAIR;
				if joker_count == {
				case 3; hand.hand_type = .FIVE_OF_A_KIND;
				case 2; hand.hand_type = .FOUR_OF_A_KIND;
				case 1; hand.hand_type = .THREE_OF_A_KIND;
				case; assert(joker_count == 0);
				}
			case .HIGH_CARD;
				if joker_count == {
				case 4; hand.hand_type = .FIVE_OF_A_KIND;
				case 3; hand.hand_type = .FOUR_OF_A_KIND;
				case 2; hand.hand_type = .THREE_OF_A_KIND;
				case 1; hand.hand_type = .ONE_PAIR;
				case; assert(joker_count == 0);
				}
			case .UNKNOWN;
				if joker_count == 5 hand.hand_type = .FIVE_OF_A_KIND;
				else assert(false);
			}
		}

		scan2(slice(line, 6, line.count-6),"%",*hand.bid);
	}
	process_file("day7", process_lines, suffix);

	sort_hands :: (a: Hand, b: Hand) -> int {
		if a.hand_type < b.hand_type return -1;
		if a.hand_type > b.hand_type return 1;
		for 0..4 {
			if a.cards[it] < b.cards[it] return -1;
			if a.cards[it] > b.cards[it] return 1;
		}
		return 0;
	}

	intro_sort(hands, sort_hands);

	winnings := 0;
	for hands {
		winnings += it.bid * (it_index+1);
	}

	return winnings;
}