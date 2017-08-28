require 'digest/sha1'
require 'ecdsa'
require 'securerandom'

SIGN_DIR = "./signatures"
MSG_DIR = "./messages"
PRIVKEY_PATH = "./keys/priv_key"

def show_help_msg
	puts "\nUSAGE:\nruby sign_messages.rb --bug <msg1> <msg2> <msg3> ..."
	puts "	- <msg1> is a string containing the message"
	puts "Description: Signs an arbitrary number of messages using ECDSA."
	puts "Output: Stores the signatures under the #{SIGN_DIR}\n\n"
end

def store_msg(counter, msg)
	msg_file = File.new("#{MSG_DIR}/msg_#{counter}", "w+")
	msg_file.write("#{msg}")
	msg_file.close
end

def sign_msg(counter, msg, insert_bug, private_key, group)
	digest = Digest::SHA1.digest(msg)
	signature = nil
	while signature.nil?
		# Generate random k
	  temp_key = gen_random_key(insert_bug, group)
	  signature = ECDSA.sign(group, private_key, digest, temp_key)
	end
	puts 'Signature: '
	puts '  r: %#x' % signature.r
	puts '  s: %#x' % signature.s
	return signature
end

def gen_random_key(insert_bug, group)
	fixed_prime_number = 35201546659608842026088328007565866231962578784643756647773109869245232364730066609837018108561065242031153677
	return insert_bug ? fixed_prime_number : (1 + SecureRandom.random_number(group.order - 1))
end

def store_der_signature(counter, signature)
	der_signature = signature_der_string = ECDSA::Format::SignatureDerString.encode(signature)
	msg_file = File.new("#{SIGN_DIR}/msg_#{counter}.sig", "w+")
	msg_file.write("#{der_signature}")
	msg_file.close
end

system "clear"

insert_bug = ARGV.size >= 1 && ARGV[0] == "--bug" ? true : false
if insert_bug
	puts "Using bug (fixed temp_key K) to generate signatures..." 
else
	puts "Generating signatures without fixed temp_key bug..."
end

num_of_messages = insert_bug ? ARGV.size-1 : ARGV.size
private_key = File.read("#{PRIVKEY_PATH}").to_i
group = ECDSA::Group::Secp256k1


puts "Using privkey  = #{private_key}"
if num_of_messages <= 0
	show_help_msg
else
	for i in (ARGV.size - num_of_messages)..(ARGV.size-1)
		message = ARGV[i]
		msg_size = message.size
		puts "================================================"
		puts "\nMessage ##{i} [SIZE=#{msg_size}]: #{message}"
		if msg_size > 0
			# Store message and sign it
			store_msg(i, message)
			puts "Signing message...\n"
			signature = sign_msg(i, message, insert_bug, private_key, group)
			store_der_signature(i, signature)
		else
			puts "Message size is 0"
		end
		puts "\n"
	end
end
puts "================================================"











