def code(&block)
  Sexp.from_array(block.to_sexp)
end

class Sexp
  def to_ruby
    Ruby2Ruby.new.process(self)
  end
end
