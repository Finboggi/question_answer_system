# Helper for anonymous controller and models tests

require 'rails_helper'
require 'with_model'

RSpec.configure do |config|
  config.extend WithModel
end
