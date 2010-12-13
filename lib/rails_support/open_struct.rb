require "ostruct"
OpenStruct.class_eval do 
  delegate :[]=, :to => :table

  # Access open struct's field with indifferent access
  def [](key)
    table[key] || table[String === key ? key.to_sym : key.to_s]
  end
end