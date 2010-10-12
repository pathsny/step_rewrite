require File.expand_path('../../requires', __FILE__)
require File.expand_path('../matcher', __FILE__)

describe StepRewrite do
  it 'allows text like call backs' do
    code { foo(&cb); bar }.should become code { foo { bar } }, :with => :cb
  end

  [
          code { a = foo(1); bar(a) },
              code { a = foo(1); bar(a) },
          code { foo(&_); bar },
              code { foo { bar } },
          code { foo(&_); bar; baz },
              code { foo { bar; baz } },
          code { a = foo; bar; baz(a, &_) },
              code { a = foo; bar; baz(a) {} },
          code { a = foo; bar(&_); j = baz(a); quux(j) },
              code { a = foo; bar { j = baz(a); quux(j) } },
          code { a = foo; bar(&_); baz(a, &_); quux },
              code { a = foo; bar { baz(a) { quux } } },
          code { foo(a).bar(b, &_); baz.qux(c, &_); quux; corge(&_); grault },
              code { foo(a).bar(b) { baz.qux(c) { quux; corge { grault } } } },
          code { begin foo(&_); bar; end until baz },
              code { begin foo { bar } end until baz},
          code { a = foo(&_); bar(a) },
              code { foo { |a| bar(a) } },
          code { a = 1; begin a = foo(&_); bar(a) end until baz},
              code { a = 1; begin foo {|a| bar(a) } end until baz },
          code { a, b, c = foo(&_); bar(a, b) },
              code { foo { |a, b, c| bar(a, b) } },
          code { *a = foo(&_); bar(a)},
              code { foo {|*a| bar(a)}},
          code { a, *b = foo(&_); bar(b)},
              code {foo {|a,*b| bar(b)}},
          code { a.b = foo(&_); bar(b)},
              code {a.b = foo { bar(b)}}
  ].each_slice(2).each_with_index do |code, index|
    it index do
      puts code.last.to_s
      code.first.should become code.last
    end
  end
end
