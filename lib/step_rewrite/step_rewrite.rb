module StepRewrite
  def step(*args, &block)
    StepRewrite.step(*args, &block)
  end

  def self.get_sexp(&block)
    Sexp.from_array(block.to_sexp)
  end

  def self.rewrite(callback_symbol = :_, &block)
    rewriter = StepRewrite::Rewriter.new(callback_symbol)
    new_sexp = rewriter.process(get_sexp(&block))
    Ruby2Ruby.new.process(new_sexp)
  end

  def self.step(*args, &block)
    eval(rewrite(*args, &block), block.binding).call
  end
end