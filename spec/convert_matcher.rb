module Spec
  module Matchers
    class Convert
      def initialize(given_code)
        @given_code = code(&given_code)
      end

      def matches?(event_proc)
        @new_code = event_proc.call(@given_code.deep_clone)
        @new_code == @expected_code
      end

      def to(&expected_code)
        @expected_code = code(&expected_code)
        self
      end

      def description
        "Convert \n#{given_code_in_ruby} INTO \n#{expected_code_in_ruby}\n\n"
      end

      [:expected, :given, :new].map{|t| "#{t}_code"}.each do |type|
        define_method "#{type}_in_ruby" do
          code = instance_variable_get("@#{type}")
          code.deep_clone.to_ruby rescue code
        end
      end

      def failure_message_for_should
<<-END
given code was converted to
#{new_code_in_ruby}
aka
got
#{@expected_code}
instead of
#{@new_code}
END
      rescue
<<-END
Expected
#{@expected_code}
got
#{@new_code}
END
      end

    end

    def convert(&given_code)
      Matchers::Convert.new(given_code)
    end
  end
end
