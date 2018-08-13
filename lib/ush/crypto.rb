require 'securerandom'

# This function is not used, but should be used in the future
def random_hex(len=16)
  raise NotImplementedError
  SecureRandom.hex(len)
end