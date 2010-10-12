Spec::Matchers.define :become do |expected_block, options|
  match do |given_block|
    @new_block = new_block(given_block.deep_clone, {:with => :_}.merge(options||{})[:with])
    @new_block == expected_block
  end

def new_block(given_block, cb)
  StepRewrite.new(cb).process(given_block)
end

  failure_message_for_should do |given_block|
    begin
    <<-END
Expected
#{Ruby2Ruby.new.process(given_block.deep_clone)}
to become
#{Ruby2Ruby.new.process(expected_block.deep_clone)}
but got
#{Ruby2Ruby.new.process(@new_block.deep_clone)}
aka
#{expected_block}
instead of
#{@new_block}
END
    rescue
<<-END
Expected
#{expected_block}
got
#{@new_block}
END
      end
  end
end
