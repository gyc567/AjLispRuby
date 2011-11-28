
module AjLisp

class Lexer
	@@separators = "()"

	def initialize(source)
		@source = source
	end
	
	def nextToken
		char = @source.nextChar
		
		while char and char =~ /\s/
			char = @source.nextChar
		end
		
		if char == nil
			return nil
		end
		
		if @@separators.include? char
			return Token.new char, TokenType::SEPARATOR
		end
		
		if char =~ /\w/
			return nextAtom char
		end
	end
	
	private
	
	def nextAtom(firstch)
		value = firstch
		
		char = @source.nextChar
		
		while char
			if char =~ /\w/
				value += char
				char = @source.nextChar
			else
				@source.pushChar char
				break
			end
		end
		
		return Token.new value, TokenType::ATOM
	end
end

end