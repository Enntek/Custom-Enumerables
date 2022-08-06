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
      self.my_each { |el| truthy_arr << el if block.call(el) }
      truthy_arr
    when Hash
      self.my_each { |k, v| truthy_hash[k] = v if block.call(k, v) }
      truthy_hash
    end
  end

  def my_all?(pattern = nil, &block)
    self.my_each { |el| return false unless pattern === el } unless block_given?

    self.my_each { |el| return false unless block.call(el) } unless pattern

    true
  end
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


  def my_count(&block)
    return self.size unless block_given?

    count = 0
    self.my_each { |el| count += 1 if block.call(el) }
    count
  end

  def my_map(&block)
    return to_enum(:my_map) unless block_given?

    array = Array.new(0)

    case self
    when Array
      self.my_each { |el| array << block.call(el) }
    when Hash
      self.my_each { |k, v| array << block.call(k, v) }
    end

    array
  end

  # experiment more with inject.
  def my_inject(accumulator = nil, &block)
    arg = args[0] unless args.nil?

    if arg.nil?
      accumulator = self.first
    else
      accumulator = arg
    end

    self.my_each do |el|
      accumulator = block.call(accumulator, el)
    end

    accumulator
  end


end

class Array
  include Enumerable
end

# arr = %w(turtle rabbit)
# hash = { a: 'apple', b: 'banana' }

arr = [2, 3]
aproc = Proc.new { |sum, n| sum * n }

# arr.my_inject(&aproc)
p arr.inject(&aproc)



