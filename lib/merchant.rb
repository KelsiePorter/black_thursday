# frozen_string_literal: true

require 'make_time'

class Merchant
  include MakeTime

  attr_accessor :name
  attr_reader   :id, :created_at

  def initialize(merchant_details)
    @id = merchant_details[:id].to_i
    @name = merchant_details[:name]
    @created_at = return_time_from(merchant_details[:created_at])
  end
end
