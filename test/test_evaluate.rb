require 'ajlisp'
require 'test/unit'

module AjLisp

class TestEvaluate < Test::Unit::TestCase
	def test_evaluate_integer
		result = evaluateText("1")
		
		assert_not_nil result
		assert result.is_a? Fixnum
		assert_equal 1, result
	end
	
	def test_evaluate_string
		result = evaluateText('"foo"')
		
		assert_not_nil result
		assert result.is_a? String
		assert_equal "foo", result
	end
	
	def test_evaluate_simple_quote
		result = evaluateText('(quote a)')
		
		assert_not_nil result
		assert result.is_a? NamedAtom
		assert_equal :a, result.name
	end
	
	def test_evaluate_quoted_list
		result = evaluateText('(quote (a b))')
		
		assert_not_nil result
		assert result.is_a? List
		assert_equal :a, result.first.name
		assert_equal :b, result.rest.first.name
		assert_nil result.rest.rest
	end

	def test_evaluate_simple_cons
		result = evaluateText('(cons (quote a) (quote (b)))')
		
		assert_not_nil result
		assert result.is_a? List
		assert_equal :a, result.first.name
		assert_equal :b, result.rest.first.name
		assert_nil result.rest.rest
	end
	
	def test_evaluate_simple_list
		result = evaluateText("(list (quote a) (quote b))")
		
		assert_not_nil result
		assert result.is_a? List
		assert_equal :a, result.first.name
		assert_equal :b, result.rest.first.name
		assert_nil result.rest.rest
	end
	
	def test_evaluate_simple_list_with_character_quote
		result = evaluateText("(list 'a 'b))")
		
		assert_not_nil result
		assert result.is_a? List
		assert_equal :a, result.first.name
		assert_equal :b, result.rest.first.name
		assert_nil result.rest.rest
	end
	
	def test_evaluate_simple_define
		result = evaluateText("(define one 1)")
		
		assert_not_nil result
		assert_equal 1, AjLisp::context.getValue(:one)
	end
	
	def test_define_and_evaluate_simple_form
		evaluateText("(define mycons (a b) (cons a b))")
		result = evaluateText('(mycons (quote a) (quote (b)))')
		
		assert_not_nil result
		assert result.is_a? List
		assert_equal :a, result.first.name
		assert_equal :b, result.rest.first.name
		assert_nil result.rest.rest
	end
	
	def test_evaluate_simple_add
		result = evaluateText("(+ 1 2)")
		assert_not_nil result
		assert result.is_a? Fixnum
		assert_equal 3, result
	end
	
	def test_define_form_with_closure
		evaluateText("(define addx (x) (lambda (a) (+ a x)))")
		evaluateText("(define addone (addx 1))")
		result = evaluateText('(addone 3)')
		
		assert_not_nil result
		assert result.is_a? Fixnum
		assert_equal 4, result
	end
	
	def test_define_form_with_free_variable
		evaluateText("(define one 1)")
		evaluateText("(define addone (x) (+ x one))")
		assert_equal 4, evaluateText('(addone 3)')
		evaluateText("(define one 2)")
		assert_equal 5, evaluateText('(addone 3)')
	end
		
	def test_evaluate_native_method_arity_0
		result = evaluateText('(.length "foo")')
		assert_equal 3, result
	end
		
	def test_evaluate_native_method_arity_1
		result = evaluateText('(.include? "foo" "o")')
		assert_equal true, result
	end
    
	def test_evaluate_simple_constant
		result = evaluateText('@String')
		assert_equal String, result
	end
    
	def test_evaluate_nested_constant
		result = evaluateText('@AjLisp::List')
		assert_equal AjLisp::List, result
	end
    
	def test_evaluate_add
		assert_equal 3, evaluateText('(+ 1 2)')
		assert_equal 6, evaluateText('(+ 1 2 3)')
		assert_equal 1, evaluateText('(+ 1)')
		assert_equal 0, evaluateText('(+)')
	end
    
	def test_evaluate_add_string
		assert_equal "foobar", evaluateText('(+ "foo" "bar")')
	end
    
	def test_evaluate_subtract
		assert_equal -1, evaluateText('(- 1 2)')
		assert_equal -4, evaluateText('(- 1 2 3)')
		assert_equal 1, evaluateText('(- 1)')
	end
    
	def test_evaluate_multiply
		assert_equal 2, evaluateText('(* 1 2)')
		assert_equal 6, evaluateText('(* 1 2 3)')
		assert_equal 1, evaluateText('(* 1)')
		assert_equal 1, evaluateText('(*)')
	end
    
	def test_evaluate_divide
		assert_equal 2, evaluateText('(/ 4 2)')
		assert_equal 2, evaluateText('(/ 8 2 2)')
		assert_equal 1, evaluateText('(/ 1)')
	end
    
	def test_evaluate_equal
		assert evaluateText('(= 2 2)')
		assert !evaluateText('(= 2 3)')
		assert evaluateText('(= "foo" "foo")')
		assert !evaluateText('(= "foo" "bar")')
	end
    
	def test_evaluate_less_than
		assert evaluateText('(< 2 3)')
		assert !evaluateText('(< 2 2)')
		assert evaluateText('(< "bar" "foo")')
		assert !evaluateText('(< "foo" "bar")')
	end
    
	def test_evaluate_greater_than
		assert evaluateText('(> 4 3)')
		assert !evaluateText('(> 2 2)')
		assert evaluateText('(> "foo" "bar")')
		assert !evaluateText('(> "bar" "foo")')
	end
    
	def test_evaluate_less_equal_than
		assert evaluateText('(<= 2 3)')
		assert evaluateText('(<= 2 2)')
		assert !evaluateText('(<= 2 1)')
		assert evaluateText('(<= "bar" "foo")')
		assert evaluateText('(<= "bar" "bar")')
		assert !evaluateText('(<= "foo" "bar")')
	end
    
	def test_evaluate_greater_equal_than
		assert evaluateText('(>= 4 3)')
		assert evaluateText('(>= 4 4)')
		assert !evaluateText('(>= 1 2)')
		assert evaluateText('(>= "foo" "bar")')
		assert evaluateText('(>= "foo" "foo")')
		assert !evaluateText('(>= "bar" "foo")')
	end
    
    def test_equal_on_atoms
        assert evaluateText("(= 'a 'a)")
        assert !evaluateText("(= 'a 'b)")
        assert !evaluateText("(= 'a 1)")
        assert !evaluateText("(= 1 'a)")
    end

    def test_equal_on_list
        assert evaluateText("(= '(a b (c d)) '(a b (c d)))")
        assert !evaluateText("(= '(a b (c d)) 'b)")
        assert !evaluateText("(= '(a b (c d)) '(a b))")
        assert !evaluateText("(= '(a b (c d)) 1)")
        assert !evaluateText("(= 1 '(a b (c d)))")
    end
    
	def evaluateText(text)
		source = StringSource.new text
		lexer = Lexer.new source
		parser = Parser.new lexer
		expr = parser.parseExpression
		return AjLisp::evaluate AjLisp::context, expr
	end
end

end