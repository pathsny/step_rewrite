module StepRewrite
  class Rewriter < SexpProcessor
    def initialize(cb)
      super()
      self.strict = false
      self.require_empty =  false
      @cb = cb
    end

    def process_block(exp)
      exp.shift
      result = exp.reverse.inject([]) {|acc, cur| accumulate(acc, process(cur))}
      exp.clear
      group_expr(result)
    end

    def group_expr(acc)
      acc.size > 1 ? s(:block, *acc) : acc.first
    end

    def remove_block(exp)
      exp.tap{|e| e[3].pop}
    end

    def new_exp_containing(acc)
      lambda do |call_exp, param|
        [s(*[:iter, remove_block(call_exp), param] + [group_expr(acc)].compact)]
      end
    end

    def accumulate(acc, cur)
      new_exp = new_exp_containing(acc)
      if special_call?(cur) then
        new_exp.call(cur, nil)
      elsif cur.first == :lasgn && special_call?(cur[2])
        new_exp.call(cur[2], s(:lasgn, cur[1]))
      elsif cur.first == :masgn && special_call?(cur[2][1])
        new_exp.call(cur[2][1], s(:masgn, s(:array, *cur[1][1..-1].to_a)))
      elsif cur.first == :attrasgn && special_call?(cur[3][1])
        new_exp.call(cur[3][1], s(:attrasgn, *cur[1..-2] + [s(:arglist)]))
      else
        acc.unshift(cur)
      end
    end

    def special_call?(exp)
      exp.first == :call &&
              exp[3].last.class == Sexp &&
              exp[3].last.first == :block_pass &&
              exp[3].last.last[2] == @cb
    end
  end
end
