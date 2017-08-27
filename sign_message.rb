require 'digest/sha1'

SIGN_DIR = "./signatures"

num_of_messages = ARGV.size
show_help_msg if num_of_messages == 0













def show_help_msg
	puts "\nUSAGE:\n sign_messages <msg1> <msg2> <msg3> ..."
	puts "Description: Signs an arbitrary number of messages using ECDSA."
	puts "Output: Stores the signatures under the #{SIGN_DIR}"
end