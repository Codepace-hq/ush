require "ush/app"
require "ush/db/sqlite"
require "ush/crypto"
require 'base64'
require 'digest/sha2'
require 'addressable/uri'

module Ush

  class Error < StandardError
  end

  # The message that the user recieves when they try to associate a used shortcode
  class DuplicateCodeError
    def self.message(new, code)
      "#{new} cannot be registered as '#{code}' because '#{code}' is already registered!"
    end
  end

  class Adapter

    # Shortens a url to a given 6 character string
    # Adapted from https://github.com/technoweenie/guillotine
    #
    # 1. SHA256 hash the url to hexdigest
    # 2. Convert to Bignum
    # 3. Pack it to a bitstring (big-endian int)
    # 4. b64encode the bitstring removeing trailing junk
    # 5. xor final string with a random value TODO
    def self.shorten(url)
      Base64.urlsafe_encode64([Digest::SHA256.hexdigest(url).to_i(16)].pack("N")).sub(/==\n?$/, '')
    end

    # Strips a url of basic badchars
    def self.parse_url(url)
      url.gsub!(/\s/, '')
      url.gsub!(/\?.*/, '')
      url.gsub!(/\#.*/, '')
      Addressable::URI.parse(url).to_s
    end

  end


end
