require File.expand_path('../../lib/step_rewrite/module', __FILE__)

describe Module do
  class Foo
    def call_adder(a)
      yield a
    end

    def plus_five(b)
      yield b + 5
    end
  end

  it 'defines methods where the special callback symbol is rewritten' do
    class Foo
      define_method_with_step :into_itself_plus_five do |a|
        res = call_adder(a, &_)
        res_2 = plus_five(res, &_)
        res_2*res
      end
    end

    Foo.new.into_itself_plus_five(5).should == 50
  end

  it 'defines methods allowing configuration of the special callback symbol' do
    class Foo
      define_method_with_step :into_itself_plus_five, :cb do |a|
        res = call_adder(a, &cb)
        _ = lambda { |res_2| res_2 * res }
        plus_five(res, &_).class
      end
    end

    Foo.new.into_itself_plus_five(5).should == 50
  end
end