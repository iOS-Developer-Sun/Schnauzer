$LOAD_PATH << '.'
require 'Schnauzer.rb'

SchnauzerSpec('SchnauzerLibrary', 'PoodleLibrary', is_library: true)
