# This script generates a private key (dA) and derives the public key from it.
# It uses the Secp256k1 EC 


require 'ecdsa'
require 'securerandom'

PRIVKEY_PATH = "./keys/priv_key"
PUBKEY_PATH = "./keys/pub_key"

puts "\nECDSA Labs - Using Secp256k1 EC"
puts "Generating the private key...\n"

group = ECDSA::Group::Secp256k1
private_key = 1 + SecureRandom.random_number(group.order - 1)
puts "----------------------------------------------------------------"
puts "The private key is (DEC): #{private_key}"
puts 'The private key is (HEX): %#x' % private_key
puts "----------------------------------------------------------------"

puts "\nDeriving the public key from it..."
public_key = group.generator.multiply_by_scalar(private_key)
public_key_string = ECDSA::Format::PointOctetString.encode(public_key, compression: true)
puts 'The public key is:'
puts "----------------------------------------------------------------"
puts '	x: %#x' % public_key.x
puts '	y: %#x' % public_key.y
puts "	PUBKEY String: #{public_key_string}"
puts "----------------------------------------------------------------"
puts "\nStoring the keys:"
puts "	-> PrivKey in #{PRIVKEY_PATH}"
private_key_file = File.new("./keys/priv_key", "w+")
private_key_file.write("#{private_key}")

puts "	-> PubKey in #{PUBKEY_PATH}"
public_key_file = File.new("./keys/pub_key", "w+")
public_key_file.write("#{public_key_string}")

