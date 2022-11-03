class SalesAnalyst
  attr_reader :items,
              :merchants


  def initialize(items, merchants)
    @items = items
    @merchants = merchants
  end

  def average_items_per_merchant
    (@items.all.size.to_f / @merchants.all.size).round(2)
  end

  def average_items_per_merchant_standard_deviation
    mean = average_items_per_merchant
    sum = array_of_items_per_merchant.sum(0.0) { |element| (element - mean) ** 2 }
    variance = sum / (@merchants.all.size - 1)
    return Math.sqrt(variance).round(2)
  end

  def array_of_items_per_merchant
    @merchants.all.map do |merchant|
      @items.find_all_by_merchant_id(merchant.id).size
    end
  end

  def merchants_with_high_item_count
    @merchants.all.select do |merchant|
      # require "pry"; binding.pry
      @items.find_all_by_merchant_id(merchant.id).size > avg_plus_std_dev
    end
    # iterate thru all merchants and find how many items they have
    # check if num of items is greater or = to 7
    # return those merchants in an array
  end

  def avg_plus_std_dev
    (average_items_per_merchant + average_items_per_merchant_standard_deviation).to_i
  end
end