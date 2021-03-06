
require 'ajlisp'
require 'test/unit'

class TestNamedAtom < Test::Unit::TestCase
	def test_initialize
		atom = AjLisp::NamedAtom.new("a")
		assert_equal(:a, atom.name)
	end
	
	def test_evaluate_in_context
		atom = AjLisp::NamedAtom.new("foo")
		context = AjLisp::Context.new
		context.setValue(:foo, "bar")
		assert_equal("bar", atom.evaluate(context))
	end 
	
	def test_atom_to_string
		atom = AjLisp::NamedAtom.new("foo")
		assert_equal "foo", atom.to_s
	end
    
    def test_atom_is_equal
        atom = AjLisp::NamedAtom.new("foo")
        atom2 = AjLisp::NamedAtom.new("foo")
        atom3 = AjLisp::NamedAtom.new("bar")
        
        assert atom.isEqualTo(atom2)
        assert atom2.isEqualTo(atom)
        assert !atom.isEqualTo(atom3)
        assert !atom3.isEqualTo(atom)
    end
end
