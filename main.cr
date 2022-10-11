require "./parser.cr"
require "./utils.cr"
require "./evaluation.cr"

raw_data = File.read(ARGV[0])

main_file = from_grouping(remove_comments raw_data)

eval = Evaluation.new main_file
eval.display
