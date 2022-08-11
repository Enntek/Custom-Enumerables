# require 'pry-byebug'
# when you iterate, the |index| argument magically appears inside the block
# that's the only magic that happens
# the elements appear because you use index to retrieve them from the array
# self.size.times { |index| yield(self[index], index) }
# when you use this iterator, you will include a block: { |element, index| code }
# behind the scenes { |index| yield(self[index], index) } what you write { |element, index| code }
# there's a block behind the scenes of your block, it has the same number of arguments
# and your block uses the parameters it passes when the method yields to your block

# observation: when you include a block i.e. arr.inject(&a_proc), the acc is nil
# ruby sees arr.inject(&a_proc) as arr.inject { your code }
# observation: to reduce/inject a hash, you must use args like this: |acc, (k, v)|
# recall: when you have an array, you can separate out the items with parens

require 'pry-byebug'

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

  # block.call returns a boolean
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

  # work on symbol argument
  def my_inject(acc = nil, &block)
    if acc.nil?
      acc = self.first
      i = 1
    else
      i = 0
    end

    case self
    when Array
      while i < self.size
        return_val = block.call(acc, self[i])
        acc = return_val
        i += 1
      end
    when Hash
      while i < self.size
        key = self.keys[i]
        value = self[keys[i]]
        return_val = block.call(acc, [key, value])
        acc = return_val
        i += 1
      end
    end

    acc
  end
end

class Array
  include Enumerable
end


arr = [10, 20, 30]
a_hash = { a: 'apple', b: 'banana' }

a_hash.my_inject({}) do |hsh, h|
  p h
  hsh
end
