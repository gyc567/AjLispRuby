require 'ajlisp'
require 'test/unit'

module AjLisp

class TestLexer < Test::Unit::TestCase
	def test_get_atom_token
		source = StringSource.new "atom"
		lexer = Lexer.new source
		token = lexer.nextToken
		
		assert_not_nil token
		assert_equal "atom", token.value
		assert_equal TokenType::ATOM, token.type
		assert_nil lexer.nextToken
	end

	def test_get_atom_token_with_spaces
		source = StringSource.new "  atom   "
		lexer = Lexer.new source
		token = lexer.nextToken
		
		assert_not_nil token
		assert_equal "atom", token.value
		assert_equal TokenType::ATOM, token.type
		assert_nil lexer.nextToken
	end

	def test_get_two_atoms
		source = StringSource.new "foo bar"
		lexer = Lexer.new source
		token = lexer.nextToken
		
		assert_not_nil token
		assert_equal "foo", token.value
		assert_equal TokenType::ATOM, token.type

		token = lexer.nextToken
		
		assert_not_nil token
		assert_equal "bar", token.value
		assert_equal TokenType::ATOM, token.type
		
		assert_nil lexer.nextToken
	end

	def test_get_parentheses
		source = StringSource.new "()"
		lexer = Lexer.new source
		token = lexer.nextToken
		
		assert_not_nil token
		assert_equal "(", token.value
		assert_equal TokenType::SEPARATOR, token.type

		token = lexer.nextToken
		
		assert_not_nil token
		assert_equal ")", token.value
		assert_equal TokenType::SEPARATOR, token.type
		
		assert_nil lexer.nextToken
	end
end

end