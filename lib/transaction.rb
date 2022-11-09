# frozen_string_literal: true

require_relative 'make_time'

class Transaction
  include MakeTime

  attr_reader :id,
              :invoice_id,
              :merchant_id,
              :credit_card_number,
              :credit_card_expiration_date,
              :result,
              :created_at,
              :updated_at

  def initialize(transaction_data)
    @id = transaction_data[:id].to_i
    @invoice_id = transaction_data[:invoice_id].to_i
    @credit_card_number = transaction_data[:credit_card_number]
    @credit_card_expiration_date = transaction_data[:credit_card_expiration_date]
    @result = transaction_data[:result].to_sym
    @created_at = return_time_from(transaction_data[:created_at])
    @updated_at = return_time_from(transaction_data[:updated_at])
  end
end
