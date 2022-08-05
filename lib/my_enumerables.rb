# require 'pry-byebug'

module Enumerable
  # Your code goes here
  def my_each
    return to_enum(:my_each) unless block_given?
    
    if self.is_a?(Array)
      self.size.times { |index| yield self[index] }
    elsif self.is_a?(Hash)
      self.size.times { |key_index| yield self.keys[key_index], self[keys[key_index]] }
    end

    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    if self.is_a?(Array)
      self.size.times { |index| yield self[index], index }
    elsif self.is_a?(Hash)
      self.size.times { |key_index| yield self.keys[key_index], self[keys[key_index]], key_index}
    end

    self
  end

  # the block is asking for a boolean value
  def my_select(&block)
    return to_enum(:my_select) unless block_given?

    truthy_arr = []
    truthy_hash = {}

    case self
    when Array
      self.my_each { |item| truthy_arr << item if block.call(item) }
      truthy_arr
    when Hash
      self.my_each { |k, v| truthy_hash[k] = v if block.call(k, v) }
      truthy_hash
    end
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  include Enumerable

end


arr = [11, 22, 33]
hash = { a: 'apple', b: 'banana' }

# my_select (select is like filter)
# p arr.my_select { |el| el > 11 }
# p arr.select
# p hash.my_select { |k,v| v.length > 5 }


# my_each_with_index
# arr.my_each_with_index { |el, index| p el, index }
# hash.my_each_with_index { |k,v,i| p k, v, i }

# my_each
# arr.my_each { |el| p el }
# p hash.my_each { |k, v| k }


