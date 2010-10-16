require 'forwardable'

module StepRewrite
  include Forwardable

  def step(*args, &block)
    StepRewrite.step(*args, &block)
  end

  def self.rewrite(callback_symbol = :_, &block)
    old_sexp = Sexp.from_array(block.to_sexp)
    new_sexp = StepRewrite::Rewriter.new(callback_symbol).process(old_sexp)
    Ruby2Ruby.new.process(new_sexp)
  end

  def self.step(*args, &block)
    eval(rewrite(*args, &block), block.binding).call
  end
end