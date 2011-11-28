require 'ajlisp'
require 'test/unit'

module AjLisp

class TestParser < Test::Unit::TestCase
	def test_parse_atom		
		source = StringSource.new "atom"
		lexer = Lexer.new source
		parser = Parser.new lexer
		
		expr = parser.parseExpression
		
		assert_not_nil expr
		assert expr.is_a? NamedAtom
		assert_equal "atom", expr.name
		
		assert_nil parser.parseExpression
	end

	def test_parse_integer
		source = StringSource.new "123"
		lexer = Lexer.new source
		parser = Parser.new lexer
		
		expr = parser.parseExpression
		
		assert_not_nil expr
		assert expr.is_a? Fixnum
		assert_equal 123, expr
		
		assert_nil parser.parseExpression
	end

	def test_parse_string
		source = StringSource.new '"foo"'
		lexer = Lexer.new source
		parser = Parser.new lexer
		
		expr = parser.parseExpression
		
		assert_not_nil expr
		assert expr.is_a? String
		assert_equal "foo", expr
		
		assert_nil parser.parseExpression
	end

	def test_parse_list
		source = StringSource.new "(foo bar)"
		lexer = Lexer.new source
		parser = Parser.new lexer
		
		expr = parser.parseExpression
		
		assert_not_nil expr
		assert expr.is_a? List
		assert_equal "foo", expr.first.name
		assert_equal "bar", expr.rest.first.name
		assert_nil expr.rest.rest
		
		assert_nil parser.parseExpression
	end
end

end