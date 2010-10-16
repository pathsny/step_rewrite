require File.expand_path('../../lib/step_rewrite', __FILE__)

describe StepRewrite do
  include StepRewrite

  def call_adder(a)
    yield a
  end

  def plus_five(b)
    yield b + 5
  end

  it 'evaluates blocks after rewriting them around the special symbol _' do
    step do
      into_two = lambda {|x| x*2}
      res = call_adder(5, &_)
      plus_five(res, &into_two)
    end.should == 20
  end

  it 'rewrites blocks using a configurable special symbol instead of _ if one is passed' do
    step(:cb) do
      _ = lambda {|x| x*2}
      res = call_adder(5, &cb)
      plus_five(res, &_)
    end.should == 20
  end

  it 'allows you to rewrite blocks without including the module' do
    StepRewrite.step do
      into_two = lambda {|x| x*2}
      res = call_adder(5, &_)
      plus_five(res, &into_two)
    end.should == 20
  end

  it 'gives you the rewritten code' do
    StepRewrite.rewrite do
      foo(&_); bar
    end.should == "proc { foo { bar } }"
  end
end

