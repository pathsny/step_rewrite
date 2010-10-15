require File.expand_path('../../requires', __FILE__)
require File.expand_path('../convert_matcher', __FILE__)

describe StepRewrite do
  describe "#process" do
    context 'when it sees the special callback symbol &cb' do
      subject { lambda { |sexp| StepRewrite.new(:cb).process(sexp) } }

      it do
        should convert {
          foo(&cb)
          bar
        }.to {
          foo { bar }
        }
      end
    end

    context "when the special callback symbol is _ " do

      subject { lambda { |sexp| StepRewrite.new(:_).process(sexp) } }

      it do
        should_not convert {
          a = foo(1)
          bar(a)
        }
      end

      it do
        should convert {
          foo(&_)
          bar
        }.to {
          foo { bar }
        }
      end

      it do
        should convert {
          foo(&_)
          bar
          baz
        }.to {
          foo do
            bar
            baz
          end
        }
      end

      it do
        should convert {
          a = foo
          bar
          baz(a, &_)
        }.to {
          a = foo
          bar
          baz(a) {}
        }
      end

      it do
        should convert {
          a = foo
          bar(&_)
          j = baz(a)
          quux(j)
        }.to {
          a = foo
          bar do
            j = baz(a)
            quux(j)
          end
        }
      end

      it do
        should convert {
          a = foo
          bar(&_)
          baz(a, &_)
          quux
        }.to {
          a = foo
          bar { baz(a) { quux } }
        }
      end

      it do
        should convert {
          foo(a).bar(b, &_)
          baz.qux(c, &_)
          quux
          corge(&_)
          grault
        }.to {
          foo(a).bar(b) do
            baz.qux(c) do
              quux
              corge { grault }
            end
          end
        }
      end

      it do
        should convert {
          begin
            foo(&_)
            bar
          end until baz
        }.to {
          begin
            foo { bar }
          end until baz
        }
      end

      it do
        should convert {
          a = foo(&_)
          bar(a)
        }.to {
          foo { |a| bar(a) }
        }
      end

      it do
        should convert {
          a = 1
          begin
            a = foo(&_)
            bar(a)
          end until baz
        }.to {
          a = 1
          begin
            foo { |a| bar(a) }
          end until baz
        }
      end

      it do
        should convert {
          a, b, c = foo(&_)
          bar(a, b)
          }.to {
          foo { |a, b, c| bar(a, b) }
        }
      end

      it do
        should convert {
          *a = foo(&_)
          bar(a)
        }.to {
          foo { |*a| bar(a) }
        }
      end

      it do
        should convert {
          a, *b = foo(&_)
          bar(b)
        }.to {
          foo { |a, *b| bar(b) }
        }
      end

      it do
        should convert {
          a.b = foo(&_)
          bar(a)
        }.to {
          foo { |a.b| bar(a) }
        }
      end

      it do
        should convert {
          a.b.c = foo(&_)
          bar(a.b)
        }.to {
          foo { |a.b.c| bar(a.b) }
        }
      end
    end
  end
end
