require "#{ROOT}/sexp_utilities"
class StepRewrite < SexpProcessor

  include SexpUtilities

  def initialize(cb)
    super()
    self.strict = false
    self.require_empty =  false
    @cb = cb
  end

  def process_block(exp)
    exp.shift
    result = exp.reverse.inject([], &method(:accumulate))
    exp.clear
    result.size > 1 ? s(:block, *result) : result.first
  end

  def accumulate(acc_exp, cur_exp)
    case identify(cur_exp)
      when :special_call then
        cur_exp[3].pop
        inner_exp = acc_exp.size > 1 ? s(:block, *acc_exp) : acc_exp.first
        [s(*[:iter, cur_exp, nil] + [inner_exp].compact)]
      when :special_asgn then
        param = cur_exp[1]
        cur_exp[2][3].pop
        inner_exp = acc_exp.size > 1 ? s(:block, *acc_exp) : acc_exp.first
        [s(*[:iter, cur_exp[2], s(:lasgn, param)] + [inner_exp].compact)]
      when :mass_asgn then
        param = cur_exp[1][1..-1].to_a
        cur_exp[2][1][3].pop
        inner_exp = acc_exp.size > 1 ? s(:block, *acc_exp) : acc_exp.first
        [s(*[:iter, cur_exp[2][1], s(:masgn, s(:array, *param))] + [inner_exp].compact)]
      else
        acc_exp.unshift(process_inner_expr(cur_exp))
    end
  end

  def special_call?(exp)
    exp.first == :call &&
            exp[3].last.class == Sexp &&
            exp[3].last.first == :block_pass &&
            exp[3].last.last[2] == @cb
  end

  def identify(exp)
    return :special_call if special_call?(exp)
    return :special_asgn if exp.first == :lasgn && special_call?(exp[2])
    return :mass_asgn if exp.first == :masgn && special_call?(exp[2][1])
  end
end

