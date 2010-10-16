require 'step_rewrite'

class Module
  def define_method_with_step(name, *args, &block)
    rewritten = StepRewrite.rewrite(*args, &block)
    instance_eval "define_method(#{name.inspect}, &#{rewritten})"
  end
end