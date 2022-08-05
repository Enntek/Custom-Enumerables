# require 'pry-byebug'

module Enumerable
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

  def my_all?(pattern = nil, &block)
    self.my_each { |item| return false unless pattern === item } unless block_given?

    self.my_each { |item| return false unless block.call(item) } unless pattern

    true
  end

  # def my_tot?(pattern = nil)
  # this line is interesting, lambda use: ->(elem) {yield elem}
  #   expr = block_given? ? ->(elem) { yield elem } : ->(elem) { pattern === elem }
  #   my_each { |elem| return false unless expr.call(elem) }
  #   true
  # end

  # Below methods will only work with arrays but will not work if the array contains
  # nil value
  # def my_every?(argv=nil, &block)
  #   # block = Proc.new { |item| item unless item.nil? || !item } unless block_given?
  #   block = Proc.new { |item| item if argv === item} unless argv.nil?
  #   self.my_each { |item| return false unless block.call(item) }
    
  #   true
  # end
end

module Enumerable

  def my_any?(pattern = nil, &block)
    self.my_each { |el| return true if pattern === el } unless block_given?

    self.my_each { |el| return true if block.call(el) } unless pattern

    false
  end

  def my_none?(pattern = nil, &block)
    return 'f is for false' if block_given? == false && pattern.nil?

    my_each { |el| return false if pattern === el } unless block_given?

    my_each { |el| return false if block.call(el) } unless pattern

    true
  end
end

class Array
  include Enumerable
end

arr = [1, 2, 3, 4]

val = 4
my_lamba = ->(el) { el == val }
my_proc = Proc.new { |el| el == val }
# my_lambda = lambda { el == val }
# my_proc = proc { |el| el == val }




# p arr.none?(String)
# p arr.my_none?(String)
# p arr.my_any?(Symbol)
# p arr.any?

# p arr.my_every? { |item| item == nil }
# hash = { a: 'apple', b: 'banana' }

# arr.my_all? { |item| p item }
# p arr.my_tot? { |item| item > 1 }

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


