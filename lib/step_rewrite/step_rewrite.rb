module StepRewrite
  def step(symbol = :_, &block)
    result = StepRewrite::Rewriter.new(symbol).process(Sexp.from_array(block.to_sexp))
    eval(Ruby2Ruby.new.process result).call
  end
end