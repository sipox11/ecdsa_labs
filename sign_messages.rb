require 'digest/sha1'

SIGN_DIR = "./signatures"
MSG_DIR = "./messages"

def show_help_msg
	puts "\nUSAGE:\nruby sign_messages.rb <msg1> <msg2> <msg3> ..."
	puts "	- <msg1> is the filename of a message stored in #{SIGN_DIR}"
	puts "Description: Signs an arbitrary number of messages using ECDSA."
	puts "Output: Stores the signatures under the #{SIGN_DIR}\n\n"
end

system "clear"
num_of_messages = ARGV.size
if num_of_messages == 0
	show_help_msg
else
	for i in 0..(ARGV.size-1)
		message = File.file?(ARGV[i]) ? File.read("#{MSG_DIR}/#{ARGV[i]}") : ""
		msg_size = message.size
		puts "================================================"
		puts "\nMessage ##{i} [SIZE=#{msg_size}]: #{message}"
		if msg_size > 0
			# sign_message(message, "#{ARGV[i]}.sig")
			puts "Signing message"
		else
			puts "Message size is 0"
		end
		puts "\n"
	end
end
puts "================================================"











